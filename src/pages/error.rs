use yew::prelude::*;

pub struct Error;

impl Component for Error {
    type Message = ();
    type Properties = ();

    fn create(_ctx: &yew::Context<Self>) -> Self {
        Self
    }

    fn view(&self, _ctx: &yew::Context<Self>) -> yew::Html {
        html! {
            <div class="not-found">
                <h1>{ "Oops!" }</h1>
                <h2>{ "404 - The Page can't be found" }</h2>
            </div>
        }
    }
}
