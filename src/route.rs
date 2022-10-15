use yew_router::prelude::*;

#[derive(Clone, Routable, PartialEq)]
pub enum Route {
    #[at("/")]
    HOME,
    #[at("/assortments")]
    ASSORTMENTS,
    #[not_found]
    #[at("/404")]
    NOTFOUND,
}