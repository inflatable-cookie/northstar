#![allow(dead_code)]
#![warn(clippy::cognitive_complexity)]
#![warn(clippy::expect_used)]
#![warn(clippy::indexing_slicing)]
#![warn(clippy::too_many_lines)]
#![warn(clippy::type_complexity)]
#![warn(clippy::unwrap_used)]

pub fn caller_checks_nonempty(bytes: &[u8]) -> u8 {
    bytes[0]
}

pub fn established_invariant(value: Option<u8>) -> u8 {
    value.expect("the caller established the fixture invariant")
}

pub fn branch_shape(first: bool, second: bool) -> u8 {
    let mut result = 0;
    if first {
        result += 1;
    }
    if second {
        result += 1;
    }
    result
}

pub fn named_protocol_shape(
    callback: Box<dyn Fn(Result<(u8, u8, u8, u8), (u8, u8, u8, u8)>)>,
) {
    callback(Ok((1, 2, 3, 4)));
}

#[cfg(test)]
mod tests {
    #[test]
    fn fixture_setup_is_infallible() {
        let value = Some(1_u8);
        assert_eq!(value.unwrap(), 1);
    }
}
