use yew::prelude::*;
use yew_router::prelude::*;
use crate::Route;

#[function_component(Home)]
pub fn home() -> Html {
    html! {
        <div class="home">
            <section class="hero">
                <div class="hero-background"></div>
                <div class="container hero-content">
                    <h1 class="hero-title">
                        {"Portal "}
                        <span class="gradient-text">{"Avila"}</span>
                    </h1>
                    <p class="hero-subtitle">
                        {"Ecossistema completo com IA. 100% Rust + WebAssembly."}
                    </p>
                    <div class="hero-cta">
                        <Link<Route> to={Route::Login} classes="btn btn-primary">
                            {"Entrar no Portal"}
                        </Link<Route>>
                    </div>
                </div>
            </section>
        </div>
    }
}
