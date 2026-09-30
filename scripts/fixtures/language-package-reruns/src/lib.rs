pub fn fixture_value() -> &'static str {
    "rerun fixture"
}

#[cfg(test)]
mod tests {
    use super::fixture_value;

    #[test]
    fn returns_fixture_value() {
        assert_eq!(fixture_value(), "rerun fixture");
    }
}
