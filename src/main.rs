use std::io::BufRead;
use syntect::easy::HighlightFile;
use syntect::highlighting::{Style, ThemeSet};
use syntect::parsing::{ParseState, ScopeStack, SyntaxSet};
use syntect::util::as_24_bit_terminal_escaped;

fn main() {
    let ss = SyntaxSet::load_from_folder(".").unwrap();
    let ts = ThemeSet::load_defaults();

    let syn = ss.find_syntax_by_name("Technique").unwrap();

    let mut parser = ParseState::new(syn);

    let input = "hello : World -> Planet";

    let result = parser.parse_line(input, &ss).unwrap();

    // println!("{:?}", result);

    let mut stack = ScopeStack::new();
    // println!("{:?}", stack);

    let mut prev = 0;

    for (next, op) in result {
        // println!("{:?} {:?}", next, op);

        stack.apply(&op).unwrap();

        let scope = stack.scopes.last().unwrap();

        println!("{}", scope.build_string());

        println!("{}", &input[prev..next]);
        prev = next;
    }
}
