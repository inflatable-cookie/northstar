#![allow(dead_code)]
#![warn(missing_debug_implementations)]
#![warn(unsafe_op_in_unsafe_fn)]
#![warn(rustdoc::broken_intra_doc_links)]
#![warn(clippy::await_holding_lock)]
#![warn(clippy::await_holding_refcell_ref)]
#![warn(clippy::incompatible_msrv)]
#![warn(clippy::missing_errors_doc)]
#![warn(clippy::missing_panics_doc)]
#![warn(clippy::missing_safety_doc)]
#![warn(clippy::undocumented_unsafe_blocks)]

use std::cell::RefCell;
use std::sync::{Mutex, OnceLock};

/// See [`UnknownType`].
pub struct MissingDebug;

pub static NEWER_THAN_MSRV: OnceLock<u8> = OnceLock::new();

pub fn parse(value: &str) -> Result<u8, std::num::ParseIntError> {
    value.parse()
}

pub fn invariant_failure() {
    panic!("fixture panic");
}

pub unsafe fn read_pointer(pointer: *const u8) -> u8 {
    *pointer
}

fn read_pointer_from_safe_function(pointer: *const u8) -> u8 {
    unsafe { *pointer }
}

pub async fn hold_lock(lock: &Mutex<u8>) {
    let guard = lock.lock().expect("fixture lock");
    std::future::ready(()).await;
    drop(guard);
}

pub async fn hold_refcell(cell: &RefCell<u8>) {
    let reference = cell.borrow();
    std::future::ready(()).await;
    drop(reference);
}
