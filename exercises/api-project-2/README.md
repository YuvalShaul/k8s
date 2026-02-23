This exercise demonstrates how to deploy a multi-service architecture using **Kubernetes Ingress** to route traffic to two different Python Flask APIs based on their URL paths.

---

## 1. The Python REST APIs

Create two separate directories, each containing an `app.py`.

### Service A: User API

This service handles user-related data.

```python
from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/users')
def get_users():
    return jsonify({"service": "User API", "data": ["Alice", "Bob"]})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

```

### Service B: Order API

This service handles order-related data.

```python
from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/orders')
def get_orders():
    return jsonify({"service": "Order API", "data": [{"id": 101, "item": "Laptop"}]})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

```

---

## 2. Dockerization & Docker Hub

- Package both applications into lightweight containers.
- Create images for both projects
- Push images (<user>/user-api:v1  user>/order-api:v1  )

---

## 3. Kubernetes Deployment & Ingress

- **Deployments:** Create two manifests. One pulls the `user-api` image and the other pulls the `order-api` image. 
- **Services:** Create two `ClusterIP` services.   These provide internal stable IPs for your pods.
- **Ingress:** Define a single Ingress resource with two rules:
  - Path `/users`  Points to **User Service**
  - Path `/orders`  Points to **Order Service**


---

## 4. Final Access

1. Deploy everything
2. Test:
* Visit `http://<ingress-ip>/users` to see the User API response.
* Visit `http://<ingress-ip>/orders` to see the Order API response.

