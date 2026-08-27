#![allow(dead_code)]
#![deny(missing_debug_implementations)]
#![deny(unsafe_op_in_unsafe_fn)]
#![deny(rustdoc::broken_intra_doc_links)]
#![deny(clippy::await_holding_lock)]
#![deny(clippy::await_holding_refcell_ref)]
#![deny(clippy::incompatible_msrv)]
#![deny(clippy::missing_errors_doc)]
#![deny(clippy::missing_panics_doc)]
#![deny(clippy::missing_safety_doc)]
#![deny(clippy::undocumented_unsafe_blocks)]

use std::cell::RefCell;
use std::sync::{Mutex, Once};

/// A documented fixture type.
#[derive(Debug)]
pub struct PublicType;

pub static MSRV_COMPATIBLE: Once = Once::new();

/// Parses one byte.
///
/// # Errors
///
/// Returns the parser error for a non-byte value.
pub fn parse(value: &str) -> Result<u8, std::num::ParseIntError> {
    value.parse()
}

/// Fails when the fixture invariant is deliberately violated.
///
/// # Panics
///
/// Always panics because this is a detector fixture.
pub fn invariant_failure() {
    panic!("fixture panic");
}

/// Reads one byte from a valid pointer.
///
/// # Safety
///
/// `pointer` must be non-null, aligned, initialized, and readable for one byte.
pub unsafe fn read_pointer(pointer: *const u8) -> u8 {
    // SAFETY: the caller supplies the documented one-byte readable pointer.
    unsafe { *pointer }
}

/// Updates the protected fixture value before suspension.
///
/// # Panics
///
/// Panics when the fixture mutex is poisoned.
pub async fn release_lock(lock: &Mutex<u8>) {
    {
        let mut guard = lock.lock().expect("fixture lock");
        *guard += 1;
    }
    std::future::ready(()).await;
}

/// Updates the borrowed fixture value before suspension.
///
/// # Panics
///
/// Panics when the fixture value is already borrowed.
pub async fn release_refcell(cell: &RefCell<u8>) {
    {
        let mut reference = cell.borrow_mut();
        *reference += 1;
    }
    std::future::ready(()).await;
}

/// Links to [`PublicType`].
pub fn documented_link() {}
