import app
import pytest

@pytest.fixture
def client():
    app.app.config['TESTING'] = True
    with app.app.test_client() as client:
        yield client

def test_home(client):
    rv = client.get('/')
    assert rv.status_code == 200
    data = rv.get_json()
    assert data.get("message") == "Hello from CI/CD Demo!"

def test_health(client):
    rv = client.get('/health')
    assert rv.status_code == 200
    assert rv.get_json().get("status") == "ok"
