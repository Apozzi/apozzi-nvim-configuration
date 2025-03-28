return {
    {
        "pangloss/vim-javascript",
        "mxw/vim-jsx",
        ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
    },
    {
        "chau-bao-long/vim-import-kotlin",
        ft = { "kotlin", "java" },
        dependencies = { "vijaymarupudi/nvim-fzf" },
        config = function()
            vim.g.learn_path = "C:/projetos"
            vim.api.nvim_set_keymap('n', '<space>il', ':KotlinImport<CR>', { noremap = true, silent = true })

            -- Função para escanear e gerar o cache
            local function learn_import_windows()
                local path = vim.g.learn_path
                if not path then return end

                local cache_file = vim.fn.expand("~") .. "\\.import.lib"
                local imports = {}

                local function scan_dir(dir)
                    local handle = vim.loop.fs_scandir(dir)
                    if not handle then return end
                    while true do
                        local name, type = vim.loop.fs_scandir_next(handle)
                        if not name then break end
                        local full_path = dir .. "\\" .. name
                        if type == "file" and (name:match("%.kt$") or name:match("%.java$")) then
                            for line in io.lines(full_path) do
                                local import = line:match("^import%s+([%w%.]+)%s*;?$")
                                if import then table.insert(imports, import) end
                            end
                        elseif type == "directory" then
                            scan_dir(full_path)
                        end
                    end
                end

                scan_dir(path)

                if #imports == 0 then return end

                local file = io.open(cache_file, "w")
                if file then
                    for _, import in ipairs(imports) do
                        file:write(import .. "\n")
                    end
                    file:close()
                end
            end

            -- Redefinir o comando :LearnImport
            vim.api.nvim_create_user_command("LearnImport", learn_import_windows, {})

            -- Comando :AutoImportKotlin para importar automaticamente
            local function auto_import_kotlin()
                local cache_file = vim.fn.expand("~") .. "\\.import.lib"
                if not vim.loop.fs_stat(cache_file) then return end

                local available_imports = {}
                for line in io.lines(cache_file) do
                    available_imports[line] = true
                end

                local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                local existing_imports = {}
                local classes_to_import = {}

                for _, line in ipairs(lines) do
                    local import = line:match("^import%s+([%w%.]+)%s*;?$")
                    if import then
                        existing_imports[import] = true
                    else
                        for word in line:gmatch("[A-Z][%w]+") do
                            if not classes_to_import[word] and word ~= "fun" and word ~= "class" then
                                classes_to_import[word] = true
                            end
                        end
                    end
                end

                local new_imports = {}
                for class_name, _ in pairs(classes_to_import) do
                    for import in pairs(available_imports) do
                        if import:match("%." .. class_name .. "$") and not existing_imports[import] then
                            table.insert(new_imports, "import " .. import)
                            existing_imports[import] = true
                            break
                        end
                    end
                end

                if #new_imports > 0 then
                    table.sort(new_imports)
                    local insert_pos = 1
                    for i, line in ipairs(lines) do
                        if not line:match("^import%s+") then
                            insert_pos = i
                            break
                        end
                    end
                    vim.api.nvim_buf_set_lines(0, insert_pos - 1, insert_pos - 1, false, new_imports)
                end
            end

            -- Registrar o comando :AutoImportKotlin
            vim.api.nvim_create_user_command("AutoImportKotlin", auto_import_kotlin, {})
	    vim.api.nvim_create_user_command("Aik", auto_import_kotlin, {})
            -- Mapeamento opcional
            vim.api.nvim_set_keymap('n', '<space>ai', ':AutoImportKotlin<CR>', { noremap = true, silent = true })

            -- Gerar o cache na inicialização
            learn_import_windows()
        end
    }
}