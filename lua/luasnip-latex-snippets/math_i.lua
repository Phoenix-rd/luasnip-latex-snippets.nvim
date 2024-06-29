local M = {}

local ls = require("luasnip")
local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe

function M.retrieve(is_math)
  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    wordTrig = false,
    condition = pipe({ is_math }),
    show_condition = is_math,
  }) --[[@as function]]

  return {
    parse_snippet({ trig = "sum", name = "sum" }, "\\sum_{${1:n=1}} ${2:a_n z^n}"),
    parse_snippet({ trig = "sumt", name = "sum_top" }, "\\sum_{${1:n=1}}^{${2:\\infty}} ${3:a_n z^n}"),

    parse_snippet(
      { trig = "taylor", name = "taylor" },
      "\\sum_{${1:k}=${2:0}}^{${3:\\infty}} ${4:c_$1} (x-a)^$1 $0"
    ),

    parse_snippet({ trig = "lim", name = "limit" }, "\\lim_{${1:n} \\to ${2:\\infty}} "),
    parse_snippet({ trig = "limsup", name = "limsup" }, "\\limsup_{${1:n} \\to ${2:\\infty}} "),

    parse_snippet(
      { trig = "prod", name = "product" },
      "\\prod_{${1:n=${2:1}}} ${3:${TM_SELECTED_TEXT}} $0"
    ),
    parse_snippet(
      { trig = "prod", name = "product_top" },
      "\\prod_{${1:n=${2:1}}}^{${3:\\infty}} ${4:${TM_SELECTED_TEXT}} $0"
    ),

    parse_snippet(
      { trig = "part", name = "d/dx" },
      "\\frac{\\partial ${1:V}}{\\partial ${2:x}} $0"
    ),
    parse_snippet(
      { trig = "dv", name = "d/dx" },
      "\\frac{\\mathrm{d}${1:y}{\\mathrm{d}${2:x} $0"
    ),

    parse_snippet({ trig = "pmat", name = "pmat" }, "\\begin{pmatrix} $1 \\end{pmatrix} $0"),

    parse_snippet(
      { trig = "lr", name = "left( right)" },
      "\\left( ${1:${TM_SELECTED_TEXT}} \\right) $0"
    ),
    parse_snippet(
      { trig = "lrp", name = "left| right|" },
      "\\left| ${1:${TM_SELECTED_TEXT}} \\right| $0"
    ),
    parse_snippet(
      { trig = "lrc", name = "left{ right}" },
      "\\left\\{ ${1:${TM_SELECTED_TEXT}} \\right\\\\} $0"
    ),
    parse_snippet(
      { trig = "lrs", name = "left[ right]" },
      "\\left[ ${1:${TM_SELECTED_TEXT}} \\right] $0"
    ),
    parse_snippet(
      { trig = "lra", name = "leftangle rightangle" },
      "\\left< ${1:${TM_SELECTED_TEXT}} \\right>$0"
    ),

    parse_snippet(
      { trig = "sequence", name = "Sequence indexed by n, from m to infinity" },
      "(${1:a}_${2:n})_{${2:n}=${3:m}}^{${4:\\infty}}"
    ),
    parse_snippet({ trig = "Template", name = "cases" }, [[
\documentclass[a4paper]{$1}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{textcomp}
\usepackage{amsmath, amssymb}
\usepackage{gensymb}
\usepackage{mhchem}
\usepackage{hyperref}
\usepackage{pgf}

\hoffset = -70pt
\voffset = -90pt
\textwidth=500pt
\textheight=700pt

% figure support
\usepackage{import}
\usepackage{xifthen}
\pdfminorversion=7
\usepackage{pdfpages}
\usepackage{transparent}

\newcommand{\incfig}[1]{%
    \def\svgwidth{\columnwidth}
    \import{./figures/}{#1.pdf_tex}
}
\newcommand{\ket}[1]{%
    \bigl| #1 \bigr> 
}
\newcommand{\bra}[1]{%
    \bigl< #1 \bigr|
}
\newcommand{\braket}[2]{%
    \bigl< #1 \bigr| #2 \bigr>
}
\newcommand{\ketbra}[2]{%
    \bigl| #1 \bigr> \bigl< #2 \bigr|
}
\pdfsuppresswarningpagegroup=1

\title{$2}
\author{$3}
\date{$4}

\begin{document}
\maketitle
$0
\end{document}
    ]]),
  }
end

return M
