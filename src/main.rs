use anyhow::{Context, Result};
use syntect::highlighting::{Highlighter, ThemeSet};
use syntect::parsing::{ParseState, Scope, ScopeStack, SyntaxSet};
use syntect::util::as_24_bit_terminal_escaped;

fn main() -> Result<()> {
    let ss = SyntaxSet::load_from_folder(".")?;

    let syn = ss
        .find_syntax_by_name("Technique")
        .context("Syntax for Technique not found")?;

    // retrieve the appropriate ANSI syntax highlighting configuration
    let theme = ThemeSet::get_theme("technique.tmTheme").expect("Theme file not found");
    let highlighter = Highlighter::new(&theme);

    let mut parser = ParseState::new(syn);

    let input = std::fs::read_to_string("Example.t").context("Failed to read example Technique file")?;

    let lines = input.lines();

    let mut stack = ScopeStack::new();

    for line in lines {
        let result = parser.parse_line(line, &ss)?;

        let mut prev = 0;
        let mut current = Scope::new("")?;

        println!("\x1b[30;107m");
        for (next, op) in result {
            stack.apply(&op)?;

            let scope = stack
                .scopes
                .last()
                .expect("No scope on stack?!?");

            let text = &line[prev..next];

            let style = highlighter.style_for_stack(std::slice::from_ref(&current));

            let output = as_24_bit_terminal_escaped(&[(style, text)], true);

            if next == prev {
                // skip printing scope if width is 0
            } else {
                println!("{:40.40} {}\x1b[30;107m", current.build_string(), output);
                prev = next;
            }

            current = *scope;
        }
    }
    println!("\x1b[0m");
    Ok(())
}
