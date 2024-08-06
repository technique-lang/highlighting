use syntect::highlighting::ThemeSet;
use syntect::parsing::{ParseState, Scope, ScopeStack, SyntaxSet};

fn main() {
    let ss = SyntaxSet::load_from_folder(".").unwrap();
    let ts = ThemeSet::load_defaults();

    let syn = ss.find_syntax_by_name("Technique").unwrap();

    let mut parser = ParseState::new(syn);

    let input = "hello : World -> Planet";

    let result = parser.parse_line(input, &ss).unwrap();

    let mut stack = ScopeStack::new();

    let mut prev = 0;
    let mut current = Scope::new("").unwrap();

    for (next, op) in result {
        stack.apply(&op).unwrap();

        let scope = stack.scopes.last().unwrap();

        println!("{}", current.build_string());

        println!("{}", &input[prev..next]);
        prev = next;

        current = *scope;
    }
}
