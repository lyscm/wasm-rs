mod utils;
mod route;
mod pages;

use crate::pages::{Home, ProductList};

use route::Route;
use yew::prelude::*;
use yew_router::prelude::*;

fn switch(routes: &Route) -> Html {
    match routes {
        Route::Home => html! { <Home /> },
        Route::ProductList => html! { <ProductList /> },
        Route::NotFound => html! { <h1>{ "404" }</h1> },
    }
}

#[function_component(App)]
pub fn app() -> Html {
    html! {        
        <div class="container">
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
