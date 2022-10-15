use yew::prelude::*;

pub struct Assortment;

impl Component for Assortment {
    type Message = ();
    type Properties = ();

    fn create(_ctx: &yew::Context<Self>) -> Self {
        Self
    }

    fn view(&self, _ctx: &yew::Context<Self>) -> yew::Html {
        html! {
            <div class="gallary">
            </div>
        }
    }
}
