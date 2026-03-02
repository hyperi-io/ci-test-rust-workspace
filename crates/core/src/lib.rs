// Project:    ci-test-rust-workspace
// License:    FSL-1.1-ALv2
// Copyright:  (c) 2026 HYPERI PTY LIMITED

/// Add two numbers.
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

/// Return a greeting for the given name.
pub fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(2, 3), 5);
    }

    #[test]
    fn test_add_negative() {
        assert_eq!(add(-1, 1), 0);
    }

    #[test]
    fn test_greet() {
        assert_eq!(greet("World"), "Hello, World!");
    }

    #[test]
    fn test_greet_name() {
        assert_eq!(greet("HyperI"), "Hello, HyperI!");
    }
}
