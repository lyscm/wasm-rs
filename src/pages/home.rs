use yew::prelude::*;

pub struct Home;

const GALLERY: [&str; 20] = [
    "https://source.unsplash.com/collection/3694365/800x600/?sig=1",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=2",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=3",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=4",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=5",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=6",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=7",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=8",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=9",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=10",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=11",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=12",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=13",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=14",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=15",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=16",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=17",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=18",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=19",
    "https://source.unsplash.com/collection/3694365/800x600/?sig=20",
];

impl Component for Home {
    type Message = ();
    type Properties = ();

    fn create(_ctx: &yew::Context<Self>) -> Self {
        Self
    }

    fn view(&self, _ctx: &yew::Context<Self>) -> yew::Html {
        html! {
            <div class="gallery">
                {for GALLERY.iter().map(|img| html! {
                    <div class="gallery-item">
                        <img src={ *img } width="400" height="500" alt="Image 1"/>
                    </div>
                })}
            </div>
        }
    }
}
