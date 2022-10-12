use wasm_bindgen::prelude::*;

#[wasm_bindgen(module = "/src/js/time.js")]
extern "C" {
    #[wasm_bindgen]
    pub fn _get_now_date() -> String;
}
