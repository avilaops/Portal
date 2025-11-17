use yew::prelude::*;
use yew_router::prelude::*;
use crate::Route;

#[function_component(Navbar)]
pub fn navbar() -> Html {
    let on_logout = Callback::from(|_| {
        if let Some(window) = web_sys::window() {
            if let Ok(Some(storage)) = window.local_storage() {
                let _ = storage.remove_item("auth_token");
                let _ = storage.remove_item("user_email");
                let _ = storage.remove_item("user_name");
            }
            let _ = window.location().set_href("/login");
        }
    });

    html! {
        <nav class="navbar">
            <div class="container">
                <div class="nav-brand">
                    <Link<Route> to={Route::Home}>
                        <span class="logo">{"?"}</span>
                        <span class="brand-name">{"Avila Portal"}</span>
                    </Link<Route>>
                </div>
                <ul class="nav-menu">
                    <li><Link<Route> to={Route::Dashboard}>{"Dashboard"}</Link<Route>></li>
                    <li><Link<Route> to={Route::Products}>{"Produtos"}</Link<Route>></li>
                    <li>
                        <button onclick={on_logout} class="btn-logout">
                            {"Sair"}
                        </button>
                    </li>
                </ul>
            </div>
        </nav>
    }
}
