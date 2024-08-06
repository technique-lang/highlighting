use anyhow::{Context, Result};
use syntect::highlighting::ThemeSet;
use syntect::parsing::{ParseState, Scope, ScopeStack, SyntaxSet};

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

        println!("{}", current.build_string());

        println!("{}", &input[prev..next]);
        prev = next;

        current = *scope;
    }
    Ok(())
}
