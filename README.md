# Geolocation API

A Ruby on Rails REST API that resolves an IP address, URL, or hostname to geolocation data and persists the result. The API currently uses IPstack to retrieve geolocation data.

---

## 🚀 Quick Start

### Requirements

- Docker Desktop
- An IPstack access key

### 1. Create `.env`

Create a `.env` file in the project root containing your IPstack access key:

```env id="o8tut9"
IPSTACK_ACCESS_KEY=your-ipstack-access-key
```

- The remaining Docker configuration is provided in `docker-compose.yml`.
- The API_KEY environment variable should be provided as a Bearer token

```text
Authorization: Bearer your-api-key
```

### 2. Start the application

```bash
docker compose up
```

Docker will automatically:

- Start PostgreSQL
- Create the database if needed
- Run pending migrations
- Seed example data (only if missing)
- Start the Rails API

The API will be available at:

```text
http://localhost:3000
```

---


## 🧪 Testing

Run the RSpec suite through Docker:

```bash
docker compose exec api bundle exec rspec
```

## 🧪 Testing

Run the test suite through Docker:

```bash
docker compose exec api bundle exec rspec
```

Alternatively, to run the tests locally, create a `.env.test` file in the project root:

```env
API_KEY=your-api-key
```

Then run:

```bash
bundle exec rspec
```


---


## 📬 Postman

A ready-to-use Postman collection is included in:

```text
postman/geolocation-api.postman_collection.json
```

Import the collection into Postman and use it to exercise the API endpoints.

---


## API

All endpoints require Bearer authentication.

The `target` is provided as a query parameter rather than a route parameter because it represents the lookup input rather than the identity of the API resource. It can also contain a URL, which makes a query parameter more natural and avoids unnecessary route encoding concerns.

### Create a geolocation

```http
POST /api/geolocations?target=8.8.8.8
```

`target` can be:

- IPv4 address
- IPv6 address
- Full URL, e.g. `https://example.com`
- Hostname, e.g. `example.com`


### Get a geolocation

```http
GET /api/geolocations?target=8.8.8.8
```


### Delete a geolocation

```http
DELETE /api/geolocations?target=8.8.8.8
```

---


## 🏗️ Design

### Provider abstraction

The geolocation integration is separated from the API and persistence logic. The application can therefore replace IPstack with another geolocation provider without requiring the API layer to know provider-specific details.

### Lookup and caching

When creating a geolocation:

1. An IP address is used directly when supplied.
2. A URL or hostname is resolved to an IP address through DNS.
3. The database is checked for an existing geolocation for that IP.
4. IPstack is only called when the IP is not already stored.
5. The resulting geolocation is persisted and returned.

This avoids unnecessary external API requests and provides a simple form of persistence-based caching.

### Error handling

The API handles invalid targets, invalid/unresolvable addresses, missing resources, and external lookup failures with JSON responses and appropriate HTTP status codes.

### Docker

The application and PostgreSQL database run through Docker Compose. Database preparation and seed data are handled automatically at startup so the application can be run without manual Rails setup.

### Test coverage

RSpec request specs cover the API behavior, including successful requests and error conditions.

---


## Seed Data

The application includes example IPv4, IPv6, and URL-based geolocations. Seeds are idempotent: existing records are not overwritten, while missing examples are created automatically on startup.