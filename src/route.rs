use yew_router::prelude::*;

#[derive(Clone, Routable, PartialEq)]
pub enum Route {
    #[at("/")]
    Home,
    #[at("/products")]
    ProductList,
    #[not_found]
    #[at("/404")]
    NotFound,
}