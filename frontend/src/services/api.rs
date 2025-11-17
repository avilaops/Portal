use gloo::net::http::Request;
use web_sys::window;
use avila_portal_shared::{LoginRequest, RegisterRequest, LoginResponse, Product, DashboardMetrics};

const BASE_URL: &str = "http://localhost:8080/api";

fn get_token() -> Option<String> {
    window()?
        .local_storage().ok()??
        .get_item("auth_token").ok()?

}

fn save_token(token: &str) {
    if let Some(storage) = window().and_then(|w| w.local_storage().ok()).flatten() {
        let _ = storage.set_item("auth_token", token);
    }
}

pub async fn login(email: &str, password: &str) -> Result<LoginResponse, String> {
    let req = LoginRequest {
        email: email.to_string(),
        password: password.to_string(),
    };

    let response = Request::post(&format!("{}/auth/login", BASE_URL))
        .header("Content-Type", "application/json")
        .json(&req)
        .map_err(|e| e.to_string())?
        .send()
        .await
        .map_err(|e| e.to_string())?;

    let data: LoginResponse = response.json().await.map_err(|e| e.to_string())?;
    save_token(&data.token);
    Ok(data)
}

pub async fn register(email: &str, password: &str, name: &str, company: Option<&str>) -> Result<LoginResponse, String> {
    let req = RegisterRequest {
        email: email.to_string(),
        password: password.to_string(),
        name: name.to_string(),
        company: company.map(|s| s.to_string()),
    };

    let response = Request::post(&format!("{}/auth/register", BASE_URL))
        .header("Content-Type", "application/json")
        .json(&req)
        .map_err(|e| e.to_string())?
        .send()
        .await
        .map_err(|e| e.to_string())?;

    let data: LoginResponse = response.json().await.map_err(|e| e.to_string())?;
    save_token(&data.token);
    Ok(data)
}

pub async fn get_products() -> Result<Vec<Product>, String> {
    let mut request = Request::get(&format!("{}/products", BASE_URL));

    if let Some(token) = get_token() {
        request = request.header("Authorization", &format!("Bearer {}", token));
    }

    let response = request
        .send()
        .await
        .map_err(|e| e.to_string())?;

    response.json().await.map_err(|e| e.to_string())
}

pub async fn get_dashboard() -> Result<DashboardMetrics, String> {
    let mut request = Request::get(&format!("{}/dashboard/metrics", BASE_URL));

    if let Some(token) = get_token() {
        request = request.header("Authorization", &format!("Bearer {}", token));
    }

    let response = request
        .send()
        .await
        .map_err(|e| e.to_string())?;

    response.json().await.map_err(|e| e.to_string())
}
