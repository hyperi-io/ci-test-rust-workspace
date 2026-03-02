// Project:    ci-test-rust-workspace
// License:    FSL-1.1-ALv2
// Copyright:  (c) 2026 HYPERI PTY LIMITED

use ci_test_core::{add, greet};

const VERSION: &str = env!("CARGO_PKG_VERSION");

fn main() {
    let args: Vec<String> = std::env::args().collect();

    if args.iter().any(|a| a == "--version") {
        println!("ci-test-cli {}", VERSION);
        return;
    }

    println!("{}", greet("World"));
    println!("2 + 3 = {}", add(2, 3));
}

#[cfg(test)]
mod tests {
    use ci_test_core::{add, greet};

    #[test]
    fn test_cli_uses_add() {
        assert_eq!(add(10, 20), 30);
    }

    #[test]
    fn test_cli_uses_greet() {
        assert_eq!(greet("CI"), "Hello, CI!");
    }
}
