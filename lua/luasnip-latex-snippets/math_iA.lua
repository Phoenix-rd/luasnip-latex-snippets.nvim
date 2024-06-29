local M = {}

local ls = require("luasnip")
local f = ls.function_node

function M.retrieve(is_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe, no_backslash = utils.pipe, utils.no_backslash

  local decorator = {
    wordTrig = false,
    condition = pipe({ is_math, no_backslash }),
  }

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, decorator) --[[@as function]]
  local s = ls.extend_decorator.apply(ls.snippet, decorator) --[[@as function]]

  return {
    s(
      {
        trig = "(%a+)bar",
        wordTrig = false,
        regTrig = true,
        name = "bar",
        priority = 100,
      },
      f(function(_, snip)
        return string.format("\\overline{%s}", snip.captures[1])
      end, {})
    ),
    s(
      {
        trig = "(%a+)und",
        wordTrig = false,
        regTrig = true,
        name = "underline",
        priority = 100,
      },
      f(function(_, snip)
        return string.format("\\underline{%s}", snip.captures[1])
      end, {})
    ),
    s(
      {
        trig = "(%a)dot",
        wordTrig = false,
        regTrig = true,
        name = "dot",
        priority = 100,
      },
      f(function(_, snip)
        return string.format("\\dot{%s}", snip.captures[1])
      end, {})
    ),

    s(
      {
        trig = "(%a+)hat",
        wordTrig = false,
        regTrig = true,
        name = "hat",
        priority = 100,
      },
      f(function(_, snip)
        return string.format("\\hat{%s}", snip.captures[1])
      end, {})
    ),
    s(
      {
        trig = "(%a+)ora",
        wordTrig = false,
        regTrig = true,
        name = "ora",
        priority = 100,
      },
      f(function(_, snip)
        return string.format("\\overrightarrow{%s}", snip.captures[1])
      end, {})
    ),
    s(
      {
        trig = "(%a+)ola",
        wordTrig = false,
        regTrig = true,
        name = "ola",
        priority = 100,
      },
      f(function(_, snip)
        return string.format("\\overleftarrow{%s}", snip.captures[1])
      end, {})
    ),

    parse_snippet({ trig = "td", name = "to the ... power ^{}" }, "^{$1}$0 "),
    parse_snippet({ trig = "rd", name = "to the ... power ^{()}" }, "^{($1)}$0 "),
    parse_snippet({ trig = "cb", name = "Cube ^3" }, "^3 "),
    parse_snippet({ trig = "sr", name = "Square ^2" }, "^2"),

    parse_snippet({ trig = "EE", name = "exists" }, "\\exists "),
    parse_snippet({ trig = "AA", name = "forall" }, "\\forall "),

    parse_snippet({ trig = "<->", name = "leftrightarrow", priority = 200 }, "\\leftrightarrow"),
    parse_snippet({ trig = "...", name = "ldots", priority = 100 }, "\\ldots "),
    parse_snippet({ trig = "!>", name = "mapsto" }, "\\mapsto "),
    parse_snippet({ trig = "iff", name = "iff" }, "\\iff"),
    parse_snippet({ trig = "siff", name = "short iff", priority = 100}, "\\Leftrightarrow"),
    parse_snippet({ trig = "ooo", name = "\\infty" }, "\\infty"),
    parse_snippet({ trig = "rij", name = "mrij" }, "(${1:x}_${2:n})_{${3:$2}\\in${4:\\N}}$0"),
    parse_snippet({ trig = "nabl", name = "nabla" }, "\\nabla "),
    parse_snippet({ trig = "<!", name = "normal" }, "\\triangleleft "),
    parse_snippet({ trig = "floor", name = "floor" }, "\\left\\lfloor $1 \\right\\rfloor$0"),
    parse_snippet({ trig = "mcal", name = "mathcal" }, "\\mathcal{$1}$0"),
    parse_snippet({ trig = "//", name = "Fraction" }, "\\frac{$1}{$2}$0"),
    parse_snippet({ trig = "\\\\\\", name = "setminus" }, "\\setminus"),
    parse_snippet({ trig = "->", name = "to", priority = 100 }, "\\to "),
    parse_snippet({ trig = "-->", name = "long to", priority = 200 }, "\\longrightarrow "),

    parse_snippet({ trig = "||", name = "norm" }, " \\left|$1\\right|$0 "),
    parse_snippet({ trig = ">>", name = ">>" }, "\\gg"),
    parse_snippet({ trig = "<<", name = "<<" }, "\\ll"),

    parse_snippet({ trig = "stt", name = "text subscript" }, "_\\text{$1} $0"),
    parse_snippet({ trig = "tt", name = "text" }, "\\text{$1}$0"),

    parse_snippet({ trig = "xx", name = "cross" }, "\\times "),

    parse_snippet({ trig = "**", name = "cdot", priority = 100 }, "\\cdot "),

    parse_snippet(
      { trig = "cvec", name = "column vector" },
      "\\begin{pmatrix} ${1:x}_${2:1}\\\\ \\vdots\\\\ $1_${2:n} \\end{pmatrix}"
    ),
    parse_snippet({ trig = "UU", name = "cup" }, "\\cup "),
    parse_snippet({ trig = "Nn", name = "cap" }, "\\cap "),
    parse_snippet({ trig = "bmat", name = "bmat" }, "\\begin{bmatrix} $1 \\end{bmatrix} $0"),
    parse_snippet({ trig = "vmat", name = "vmat" }, "\\begin{vmatrix} $1 \\end{vmatrix} $0"),
    parse_snippet({ trig = "uuu", name = "bigcup" }, "\\bigcup_{${1:i \\in ${2: I}}} $0"),
    parse_snippet({ trig = "DD", name = "D" }, "\\mathbb{D}"),
    parse_snippet({ trig = "HH", name = "H" }, "\\mathbb{H}"),
    parse_snippet({ trig = "lll", name = "l" }, "\\ell"),
    parse_snippet(
      { trig = "dint", name = "integral", priority = 300 },
      "\\int_{${1:-\\infty}}^{${2:\\infty}} ${3:${TM_SELECTED_TEXT}} $0"
    ),

    parse_snippet({ trig = "==", name = "equals" }, [[&= $1 \\\\]]),
    parse_snippet({ trig = "!=", name = "not equals" }, "\\neq "),
    parse_snippet({ trig = "compl", name = "complement" }, "^{c}"),
    parse_snippet({ trig = "__", name = "subscript" }, "_{$1}$0"),
    parse_snippet({ trig = "=>", name = "implies" }, "\\implies"),
    parse_snippet({ trig = "simp", name = "short implies" }, "\\Rightarrow"),
    parse_snippet({ trig = "=<", name = "implied by" }, "\\impliedby"),
    parse_snippet({ trig = "<<", name = "<<" }, "\\ll"),

    parse_snippet({ trig = "<=", name = "leq" }, "\\le "),
    parse_snippet({ trig = ">=", name = "geq" }, "\\ge "),
    parse_snippet({ trig = "invs", name = "inverse" }, "^{-1}"),

    --Bold
    parse_snippet({ trig = "bf", name = "mathbf" }, "\\mathbf{$1}$0"),


    --Greek snippets
    --small
    parse_snippet({ trig = ";a", name = "alpha" }, "\\alpha"),
    parse_snippet({ trig = ";b", name = "beta" }, "\\beta"),
    parse_snippet({ trig = ";g", name = "gamma" }, "\\gamma"),
    parse_snippet({ trig = ";e", name = "epsilon" }, "\\epsilon"),
    parse_snippet({ trig = ";p", name = "phi" }, "\\phi"),
    parse_snippet({ trig = ";y", name = "psi" }, "\\psi"),
    parse_snippet({ trig = ";s", name = "sigma" }, "\\sigma"),
    parse_snippet({ trig = ";o", name = "omega" }, "\\omega"),
    parse_snippet({ trig = ";q", name = "theta" }, "\\theta"),
    parse_snippet({ trig = ";l", name = "lambda" }, "\\lambda"),
    parse_snippet({ trig = ";n", name = "nu" }, "\\nu"),
    parse_snippet({ trig = ";m", name = "mu" }, "\\mu"),
    parse_snippet({ trig = ";d", name = "delta" }, "\\delta"),
    parse_snippet({ trig = ";t", name = "tau" }, "\\tau"),
    parse_snippet({ trig = ";r", name = "rho" }, "\\rho"),
    --big
    parse_snippet({ trig = ";A", name = "Alpha" }, "\\Alpha"),
    parse_snippet({ trig = ";B", name = "Beta" }, "\\Beta"),
    parse_snippet({ trig = ";G", name = "Gamma" }, "\\Gamma"),
    parse_snippet({ trig = ";E", name = "Epsilon" }, "\\Epsilon"),
    parse_snippet({ trig = ";P", name = "Phi" }, "\\Phi"),
    parse_snippet({ trig = ";Y", name = "Psi" }, "\\Psi"),
    parse_snippet({ trig = ";S", name = "Sigma" }, "\\Sigma"),
    parse_snippet({ trig = ";O", name = "Omega" }, "\\Omega"),
    parse_snippet({ trig = ";Q", name = "Theta" }, "\\Theta"),
    parse_snippet({ trig = ";L", name = "Lambda" }, "\\Lambda"),
    parse_snippet({ trig = ";N", name = "Nu" }, "\\Nu"),
    parse_snippet({ trig = ";M", name = "Mu" }, "\\Mu"),
    parse_snippet({ trig = ";D", name = "Delta" }, "\\Delta"),
    parse_snippet({ trig = ";T", name = "Tau" }, "\\Tau"),
    parse_snippet({ trig = ";R", name = "Rho" }, "\\Rho"),

    --Braces
    parse_snippet({ trig = "(", name = "()" }, "($1)$0"),
    parse_snippet({ trig = "[", name = "[]" }, "[$1]$0"),
    parse_snippet({ trig = "{", name = "{}" }, "{$1}$0"),

    --Quantum mechanics
    parse_snippet({ trig = "ket", name = "ket" }, "\\ket{$1}$0"),
    parse_snippet({ trig = "bra", name = "bra" }, "\\bra{$1}$0"),
    parse_snippet({ trig = "inp", name = "braket" }, "\\braket{$1}{$2}$0"),
    parse_snippet({ trig = "oup", name = "ketbra" }, "\\ketbra{$1}{$2}$0"),
    parse_snippet({ trig = "dag", name = "dagger" }, "^{\\dag}$0"),
  }
end

return M
