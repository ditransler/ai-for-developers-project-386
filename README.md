# Calendar Booking. Hexlet Edu Project

[![Actions Status](https://github.com/ditransler/ai-for-developers-project-386/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/ditransler/ai-for-developers-project-386/actions)

## Project Description

“Calendar Booking” is a simplified time-booking service inspired by Cal.com.

Cal.com is a service where a user publishes available time slots, and another person selects a free time and books a meeting. Our application follows the same core scenario, a single use case: the owner publishes available time slots for meetings, and another user selects a free slot and books a call.

The project does not include authentication, user accounts, or integrations with external calendars. The functionality is intentionally limited to focus on the essentials.

As a result, you should end up with a small but complete application. A user can see available slots, choose a time, and make a booking, while the calendar owner can view a list of upcoming meetings. This is enough to go through the entire process from design to deploying the service in the cloud.

## What We Learn

In this project, we go through the full development cycle of a small web application with AI as a working tool. First, we need to define what exactly the application should do and establish a contract between the client and the server. Then, based on this contract, we sequentially build the interface, implement the backend, cover the main scenarios with tests, and prepare the service for deployment.

The project teaches not just how to write code, but how to structure development in stages. It’s important to first agree on system behavior, then implement it in the interface and on the server, and finally verify everything at the level of user scenarios.

The key working format in this project is that all development is done with the help of AI agents. Ideally, you don’t write a single line of code manually: you formulate tasks for the agent, review the result, and iteratively improve the solution.

The project can be completed using any technology stack. The limitation is not defined by the language or framework, but by the final result: the application must be packaged into a Docker image and run in a container. This approach allows you to focus on architecture and the API contract rather than on choosing specific tools.

### Design First and the API contract

We use a **Design First** workflow: we agree on behavior and the **HTTP API contract first**, then implement the **frontend and backend separately** against that shared contract. The contract is the single place where the two sides align, so neither has to reverse-engineer the other.

We describe the contract in **TypeSpec**. TypeSpec is a language for API definitions; from it we can emit **OpenAPI** and generate code for many stacks. It looks a little like TypeScript syntactically, but it is not a full programming language—only the API and related metadata belong there. See [TypeSpec](https://typespec.io/).

That contract-first flow matters for AI-assisted development: agents can implement from an explicit specification instead of reading large amounts of application code, which keeps work cheaper and easier to steer. When behavior changes, you update the contract and then adjust both client and server in step—without rediscovering the whole system each time.

## API contract (TypeSpec)

The HTTP contract and generated OpenAPI live under [`api-contract/`](api-contract/): [`api-contract/main.tsp`](api-contract/main.tsp) and [`api-contract/openapi.yaml`](api-contract/openapi.yaml).

From the repository root, install dependencies and compile:

```bash
cd api-contract && npm ci
cd .. && make tsp-openapi
```

## Links

[Cal.com](https://cal.com) — a reference service that can be used as a guide when designing the user flow.
