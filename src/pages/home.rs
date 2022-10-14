use yew::prelude::*;

pub struct Home;

const GALLERY_URL: &str = "https://source.unsplash.com/collection/3694365/800x600";
const GALLERY_ITEM_SIZE: f32 = 400f32;

impl Component for Home {
    type Message = ();
    type Properties = ();

    fn create(_ctx: &yew::Context<Self>) -> Self {
        Self
    }

    fn view(&self, _ctx: &yew::Context<Self>) -> yew::Html {
        html! {
            <div class="gallery">
                {for (0..20).into_iter().map(|sig| {

                    let url = format!("{}?sig={}", GALLERY_URL, sig);
                    let alt = format!("Image {}", sig);
                    let weight = GALLERY_ITEM_SIZE * (3./4.);
                    let height = GALLERY_ITEM_SIZE;

                    html! {
                        <div class="gallery-item">
                            <img src={ url } alt={ alt } width={ weight.to_string() } height={ height.to_string() } />
                        </div>
                    }
                })}
            </div>
        }
    }
}
