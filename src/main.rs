mod pages;
mod route;
mod utils;
mod models;

use crate::pages::*;

use route::Route;
use yew::prelude::*;
use yew_router::prelude::*;

fn switch(routes: &Route) -> Html {
    match routes {
        Route::HOME => html! { <Home /> },
        Route::ASSORTMENTS => html! { <Assortment /> },
        Route::NOTFOUND => html! { <Error /> },
    }
}

#[function_component(App)]
pub fn app() -> Html {
    html! {
        <div class="container">
            // <div class="logo-row">
            //     <img alt="logo" src="img/logo.png" class="single-box-logo" />
            // </div>
            <BrowserRouter>
                <Switch<Route> render={ Switch::render(switch) } />
            </BrowserRouter>
        </div>
    }
}

fn main() {
    wasm_logger::init(wasm_logger::Config::default());
    yew::start_app::<App>();
}
