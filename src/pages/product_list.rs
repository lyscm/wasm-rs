use yew::prelude::*;

pub struct ProductList {}

impl Component for ProductList {
    type Message = ();
    type Properties = ();

    fn create(_ctx: &yew::Context<Self>) -> Self {
        Self {}
    }

    fn view(&self, _ctx: &yew::Context<Self>) -> yew::Html {
        html! {
            <div id="content">
                <p><a href="/"><img title="logo" src="/static/logo.png" /></a></p>
            </div>
        }
    }
}