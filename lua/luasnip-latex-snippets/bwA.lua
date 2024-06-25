local ls = require("luasnip")
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local M = {}

function M.retrieve(not_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe = utils.pipe

  local conds = require("luasnip.extras.expand_conditions")
  local condition = pipe({ conds.line_begin, not_math })

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = condition,
  }) --[[@as function]]

  local s = ls.extend_decorator.apply(ls.snippet, {
    condition = condition,
  }) --[[@as function]]

  return {
    s(
      { trig = "ali", name = "Align" },
      { t({ "\\begin{align*}", "\t" }), i(1), t({ "", "\\end{align*}" }) }
    ),

    parse_snippet({ trig = "beg", name = "begin{} / end{}" }, "\\begin{$1}\n\t$0\n\\end{$1}"),
    parse_snippet({ trig = "case", name = "cases" }, "\\begin{cases}\n\t$1\n\\end{cases}"),
    parse_snippet({ trig = "fig", name = "figure" }, [[
\begin{figure}[!htbp]
    \centering
    \includegraphics[width=$1\textwidth]{$2}
    \caption{$3}
    \label{$4}
\end{figure}$5
    ]]),

    parse_snippet({ trig = "table", name = "table" }, [[
\begin{table}[!htbp]
    \begin{center}
        \begin{tabular}{$1}
            $2
        \end{tabular}
    \end{center}
    \caption{$3}
    \label{$4}
\end{table}
    ]]),
    s({ trig = "bigfun", name = "Big function" }, {
      t({ "\\begin{align*}", "\t" }),
      i(1),
      t(":"),
      t(" "),
      i(2),
      t("&\\longrightarrow "),
      i(3),
      t({ " \\", "\t" }),
      i(4),
      t("&\\longmapsto "),
      i(1),
      t("("),
      i(4),
      t(")"),
      t(" = "),
      i(0),
      t({ "", ".\\end{align*}" }),
    }),

    s( -- This snippets creates the sympy block
        { trig = "sym", desc = "Creates a sympy block" },
        fmt("sympy {} sympy{}",
            { i(1), i(0) }
        )
    ),

    s( -- This one evaluates anything inside the simpy block
        { trig = "sympy.*sympy", regTrig = true, desc = "Sympy block evaluator" },
        d(1, function(_, parent)
            -- Gets the part of the block we actually want, and replaces spaces
            -- at the beginning and at the end
            local to_eval = string.gsub(parent.trigger, "^sympy(.*)sympy", "%1")
            to_eval = string.gsub(to_eval, "^%s+(.*)%s+$", "%1")

            local Job = require("plenary.job")

            local sympy_script = string.format(
                [[
    from sympy import *
    from sympy.parsing.sympy_parser import parse_expr
    from sympy.printing.latex import print_latex
    parsed = parse_expr('%s')
    print_latex(parsed)
                ]],
                to_eval
            )

            sympy_script = string.gsub(sympy_script, "^[\t%s]+", "")
            local result = ""

            Job:new({
                command = "python",
                args = {
                    "-c",
                    sympy_script,
                },
                on_exit = function(j)
                    result = j:result()
                end,
            }):sync()

            return sn(nil, t(result))
        end)
    )
}
end

return M
