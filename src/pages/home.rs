use yew::prelude::*;

pub struct Home {}

impl Component for Home {
    type Message = ();
    type Properties = ();

    fn create(_ctx: &yew::Context<Self>) -> Self {
        Self {}
    }

    fn view(&self, _ctx: &yew::Context<Self>) -> yew::Html {
        html! {
            <div class="cardContent">
                <div class="logo">
                    <img title="logo" src="/static/logo.png" />
                </div>
                <div class="cardLink">
                    <a href="https://instagram.com/mker21" class="link">{ "instagram" }</a>
                    <a href="https://tiktok.com/@mker27_" class="link">{ "tikTok" }</a>
                    <a href="https://github.com/lyscm" class="link">{ "gitHub" }</a>
                    <a href="/products" class="link">{ "webshop" }</a>
                </div>
            </div>
        }
    }
}