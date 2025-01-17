local Utils = require "pears.utils"

return function(conf, opts)
  conf.pair("<*>", {
    close = "</*>",
    filetypes = opts.filetypes or {
      include = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "php",
        "jsx",
        "tsx",
        "html",
        "xml"}},
    capture_content = "^[a-zA-Z_\\-]+",
    expand_when = "[>]",
    should_expand = function(args)
      local before = Utils.get_surrounding_chars(args.bufnr, args.context.range:end_(), 1)

      -- Don't expand for self closing tags <input type="text" />
      local should_expand = before ~= "/"

      -- Don't expand when there is a preceding character "SomeClass<T> (only for tsx)"
      if should_expand and string.match(args.lang, "(typescript|tsx)") then
        local before_context = Utils.get_surrounding_chars(args.bufnr, args.context.range:start())

        should_expand = not string.match(before_context, "[a-zA-Z0-9]")
      end

      return should_expand
    end})
end

