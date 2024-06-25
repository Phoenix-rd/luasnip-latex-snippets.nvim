local ls = require("luasnip")
local t = ls.text_node
local i = ls.insert_node

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
      { t({ "\\begin{align*}", "\t" }), i(1), t({ "", ".\\end{align*}" }) }
    ),

    parse_snippet({ trig = "beg", name = "begin{} / end{}" }, "\\begin{$1}\n\t$0\n\\end{$1}"),
    parse_snippet({ trig = "case", name = "cases" }, "\\begin{cases}\n\t$1\n\\end{cases}"),
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
  }
end

return M
