use std::io::BufRead;
use syntect::easy::HighlightFile;
use syntect::highlighting::{Style, ThemeSet};
use syntect::parsing::SyntaxSet;
use syntect::util::as_24_bit_terminal_escaped;

fn main() {
    let ss = SyntaxSet::load_from_folder(".").unwrap();
    let ts = ThemeSet::load_defaults();

    let mut highlighter = HighlightFile::new(
        "Example.t",
        &ss,
        &ts.themes["Solarized (dark)"],
    ).unwrap();
    for maybe_line in highlighter.reader.lines() {
        let line = maybe_line.unwrap();
        let regions: Vec<(Style, &str)> = highlighter
            .highlight_lines
            .highlight_line(&line, &ss).unwrap();
        println!("{}", as_24_bit_terminal_escaped(&regions[..], true));
    }
}
