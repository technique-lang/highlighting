use anyhow::{Context, Result};
use syntect::highlighting::{Highlighter, ThemeSet};
use syntect::parsing::{ParseState, Scope, ScopeStack, SyntaxSet};
use syntect::util::as_24_bit_terminal_escaped;

fn main() -> Result<()> {
    let ss = SyntaxSet::load_from_folder(".")?;
    let ts = ThemeSet::load_defaults();

    let syn = ss
        .find_syntax_by_name("Technique")
        .context("Syntax for Technique not found")?;

    let mut parser = ParseState::new(syn);

    let input = "hello : World -> Planet";

    let result = parser.parse_line(input, &ss)?;

    let mut stack = ScopeStack::new();

    let mut prev = 0;
    let mut current = Scope::new("")?;

    for (next, op) in result {
        stack.apply(&op)?;

        let scope = stack
            .scopes
            .last()
            .expect("No scope on stack?!?");

        // retrieve the appropriate ANSI syntax highlighting for the scope

        let theme = ts
            .themes
            .get("Solarized (dark)")
            .expect("Theme not found");

        let highlighter = Highlighter::new(theme);

        let text = &input[prev..next];

        let style = highlighter.style_for_stack(std::slice::from_ref(&current));

        let output = as_24_bit_terminal_escaped(&[(style, text)], true);

        println!("{:35.35} {}\x1b[0m", current.build_string(), output);
        prev = next;

        current = *scope;
    }
    Ok(())
}
