# Practical 1: Basics of Database, its Applications and Data Models

## Objective

DBMS helps to understand how data is stored, organized, and accessed in computer systems, and its applications in managing large amounts of information efficiently through the use of data models.

## Course Outcomes

- **CO1**: Understand the fundamental concepts of database systems and role of databases in sustainable development and identify eco-friendly practices in database systems

## Practical Outcomes

Students will be able to understand recent database trends and tools.

---

## Part A: Current Database Trends Report (2024-2026)

### 1. Cloud-Native Databases

Cloud-native databases are designed specifically for cloud environments, offering scalability, resilience, and managed services.

**Key Trends:**

- **Serverless Databases**: AWS Aurora Serverless, Azure SQL Database Serverless, Google Cloud Firestore
- **Multi-Cloud Support**: Databases that work across AWS, Azure, and GCP
- **Database-as-a-Service (DBaaS)**: Fully managed solutions reducing operational overhead

**Examples:**

- **Amazon Aurora**: MySQL and PostgreSQL-compatible relational database
- **Google Cloud Spanner**: Globally distributed, horizontally scalable database
- **Azure Cosmos DB**: Multi-model globally distributed database

### 2. NoSQL and NewSQL Databases

NoSQL databases continue to dominate for handling unstructured and semi-structured data, while NewSQL combines SQL benefits with NoSQL scalability.

**Popular NoSQL Categories:**

- **Document Databases**: MongoDB, Couchbase, Firebase
- **Key-Value Stores**: Redis, Amazon DynamoDB, Memcached
- **Column-Family Stores**: Apache Cassandra, HBase, ScyllaDB
- **Graph Databases**: Neo4j, Amazon Neptune, ArangoDB

**NewSQL Examples:**

- **CockroachDB**: Distributed SQL database with PostgreSQL compatibility
- **TiDB**: MySQL-compatible distributed database
- **YugabyteDB**: PostgreSQL-compatible distributed SQL database

### 3. Time-Series Databases

Optimized for handling time-stamped data, essential for IoT, monitoring, and analytics.

**Leading Solutions:**

- **InfluxDB**: Purpose-built for time-series data
- **TimescaleDB**: PostgreSQL extension for time-series
- **Prometheus**: Monitoring and alerting database

**Use Cases:**

- IoT sensor data collection
- Application performance monitoring (APM)
- Financial market data analysis
- DevOps metrics and observability

### 4. Vector Databases

Emerging trend driven by AI/ML applications, particularly for similarity search and embeddings.

**Key Players:**

- **Pinecone**: Managed vector database for machine learning
- **Weaviate**: Open-source vector search engine
- **Milvus**: Open-source vector database for AI applications
- **pgvector**: PostgreSQL extension for vector similarity search

**Applications:**

- Semantic search
- Recommendation systems
- Image and video similarity search
- Large Language Model (LLM) applications

### 5. Edge Databases

Lightweight databases designed to run on edge devices and IoT endpoints.

**Examples:**

- **SQLite**: Still dominant for embedded and mobile applications
- **PouchDB**: JavaScript database for web and mobile
- **LiteDB**: .NET NoSQL embedded database
- **Realm**: Mobile-first database (now part of MongoDB)

### 6. Database Security and Compliance

Increasing focus on data privacy, encryption, and regulatory compliance.

**Trends:**

- **Always-On Encryption**: Transparent Data Encryption (TDE)
- **Zero-Trust Architecture**: Fine-grained access controls
- **Data Masking and Anonymization**: Privacy-preserving techniques
- **Compliance Standards**: GDPR, HIPAA, SOC 2, ISO 27001

### 7. Database Automation and AI-Driven Operations

Autonomous databases that self-tune, self-repair, and self-secure.

**Key Features:**

- **Auto-Scaling**: Automatic resource allocation based on workload
- **Self-Tuning**: AI-driven query optimization
- **Predictive Maintenance**: Anomaly detection and automated fixes
- **Intelligent Indexing**: Automatic index recommendations

**Examples:**

- **Oracle Autonomous Database**: AI-powered self-driving database
- **Azure SQL Database**: Built-in intelligence features
- **Amazon RDS Performance Insights**: Automated performance monitoring

### 8. Multi-Model Databases

Single database supporting multiple data models (document, graph, key-value, relational).

**Examples:**

- **ArangoDB**: Document, graph, and key-value in one
- **OrientDB**: Multi-model database with graph capabilities
- **FaunaDB**: Distributed multi-model database with GraphQL support

### 9. Real-Time and Streaming Databases

Databases designed for real-time data processing and stream analytics.

**Solutions:**

- **Apache Kafka + KSQL**: Stream processing with SQL
- **Materialize**: Streaming SQL database
- **RisingWave**: Distributed SQL database for stream processing

### 10. Green Computing and Sustainable Databases

Growing emphasis on energy-efficient database operations and carbon footprint reduction.

**Practices:**

- **Resource Optimization**: Efficient query execution and indexing
- **Data Center Efficiency**: Use of renewable energy
- **Data Lifecycle Management**: Archiving and purging old data
- **Serverless Architecture**: Pay-per-use models reducing idle resource consumption

---

## Part B: Famous Websites and Mobile Applications with Database Tools

### Social Media Platforms

| Website/App | Primary Database Technology | Additional Data Stores | Purpose |
|-------------|----------------------------|------------------------|---------|
| **Facebook/Meta** | MySQL (sharded), TAO (graph store), Cassandra | RocksDB, Memcached, Redis | User profiles, posts, relationships, messaging |
| **Instagram** | PostgreSQL, Cassandra | Redis, Memcached | Photos, user data, feeds, stories |
| **Twitter/X** | Manhattan (distributed), MySQL | Redis, Memcached | Tweets, timelines, user data |
| **LinkedIn** | Espresso (document store), Voldemort | Redis, Kafka | Professional profiles, connections, posts |
| **Snapchat** | Google Cloud Bigtable, Redis | Memcached, Cloud Storage | Ephemeral messages, stories, user data |
| **TikTok** | MySQL, MongoDB, Redis | Cassandra, Cloud storage | Videos, user profiles, recommendations |
| **Pinterest** | MySQL (sharded), HBase, Redis | Memcached, S3 | Pins, boards, user data, image metadata |
| **Reddit** | PostgreSQL, Cassandra | Redis, Memcached | Posts, comments, voting, user karma |

### E-Commerce Platforms

| Website/App | Primary Database Technology | Additional Data Stores | Purpose |
|-------------|----------------------------|------------------------|---------|
| **Amazon** | DynamoDB, Aurora, Oracle | Redis, S3, Redshift | Products, orders, inventory, recommendations |
| **eBay** | Oracle, MongoDB, Cassandra | Redis, Couchbase | Listings, auctions, transactions |
| **Alibaba** | OceanBase, MySQL | Redis, HBase | Products, orders, payments |
| **Shopify** | MySQL (sharded), Redis | Memcached, Elasticsearch | Stores, products, orders |
| **Walmart** | Cassandra, Oracle | Neo4j (product graph), Kafka | Inventory, orders, supply chain |
| **Flipkart** | MySQL, MongoDB, Cassandra | Redis, Elasticsearch | Products, orders, search |

### Streaming and Entertainment

| Website/App | Primary Database Technology | Additional Data Stores | Purpose |
|-------------|----------------------------|------------------------|---------|
| **Netflix** | Cassandra, MySQL, PostgreSQL | Redis, S3, Elasticsearch | User profiles, viewing history, recommendations |
| **YouTube** | Bigtable, Spanner, MySQL | Memcached, Cloud Storage | Videos metadata, comments, analytics |
| **Spotify** | Cassandra, PostgreSQL | Redis, Google Cloud Storage | Music catalog, playlists, user preferences |
| **Twitch** | DynamoDB, Aurora, PostgreSQL | Redis, S3 | Streams, chat, user data |
| **Disney+** | DynamoDB, Aurora | Redis, S3 | Content catalog, user profiles, playback data |
| **Prime Video** | DynamoDB, Aurora, Redshift | Redis, S3, Kinesis | Content, users, recommendations, analytics |

### Financial Technology (FinTech)

| Website/App | Primary Database Technology | Additional Data Stores | Purpose |
|-------------|----------------------------|------------------------|---------|
| **PayPal** | Oracle, MySQL, MongoDB | Redis, Cassandra | Transactions, accounts, fraud detection |
| **Stripe** | MongoDB, PostgreSQL | Redis, Elasticsearch | Payments, subscriptions, transactions |
| **Venmo** | PostgreSQL, DynamoDB | Redis | Peer-to-peer payments, transactions |
| **Square** | MySQL, MongoDB | Redis, Kafka | Payments, inventory, analytics |
| **Robinhood** | PostgreSQL, CockroachDB | Redis, Kafka | Trading, portfolios, market data |
| **Coinbase** | MongoDB, PostgreSQL | Redis, Kafka | Cryptocurrency transactions, wallets |

### Travel and Transportation

| Website/App | Primary Database Technology | Additional Data Stores | Purpose |
|-------------|----------------------------|------------------------|---------|
| **Uber** | MySQL, PostgreSQL, Cassandra | Redis, Schemaless (JSON store) | Rides, drivers, locations, trips |
| **Lyft** | MySQL, DynamoDB | Redis, S3 | Rides, drivers, pricing, locations |
| **Airbnb** | MySQL (sharded), Redis | Memcached, S3 | Listings, bookings, reviews |
| **Booking.com** | MySQL, Oracle | Redis, Elasticsearch | Hotels, bookings, availability |
| **Expedia** | Oracle, SQL Server, Cassandra | Redis, Elasticsearch | Travel inventory, bookings, prices |

### Cloud and Productivity

| Website/App | Primary Database Technology | Additional Data Stores | Purpose |
|-------------|----------------------------|------------------------|---------|
| **Google Drive** | Bigtable, Spanner, Blobstore | Colossus (file system) | Files, metadata, sharing |
| **Dropbox** | MySQL (sharded), Edgestore | S3, Memcached | Files, user data, sharing |
| **Microsoft 365** | SQL Server, Azure Cosmos DB | Azure Storage, Redis | Documents, user data, collaboration |
| **Notion** | PostgreSQL, S3 | Redis | Documents, workspaces, collaboration |
| **Slack** | MySQL (sharded), Vitess | Redis, S3 | Messages, channels, files |
| **Zoom** | MySQL, MongoDB | Redis, Kafka | Meetings, recordings, user data |

### Gaming

| Website/App | Primary Database Technology | Additional Data Stores | Purpose |
|-------------|----------------------------|------------------------|---------|
| **Fortnite (Epic Games)** | PostgreSQL, DynamoDB | Redis, S3 | Player profiles, game state, leaderboards |
| **Roblox** | MySQL, Cassandra | Redis, Memcached | User-generated content, game data |
| **Steam** | MySQL, Redis | Memcached | Game library, purchases, user profiles |
| **Discord** | Cassandra, ScyllaDB, MongoDB | Redis | Messages, servers, voice channels |

### Food Delivery

| Website/App | Primary Database Technology | Additional Data Stores | Purpose |
|-------------|----------------------------|------------------------|---------|
| **DoorDash** | PostgreSQL, DynamoDB | Redis, Kafka | Orders, restaurants, delivery tracking |
| **Uber Eats** | MySQL, Cassandra | Redis, Kafka | Restaurants, orders, deliveries |
| **GrubHub** | PostgreSQL, MySQL | Redis, Elasticsearch | Restaurants, orders, menus |
| **Zomato** | MySQL, MongoDB, Cassandra | Redis, Elasticsearch | Restaurants, reviews, orders |
| **Swiggy** | PostgreSQL, MongoDB | Redis, Kafka | Restaurants, orders, delivery |

### Education Technology

| Website/App | Primary Database Technology | Additional Data Stores | Purpose |
|-------------|----------------------------|------------------------|---------|
| **Coursera** | MySQL, MongoDB | Redis, S3 | Courses, enrollments, progress |
| **Khan Academy** | PostgreSQL, Cloud Datastore | Memcached, Cloud Storage | Exercises, videos, student progress |
| **Duolingo** | PostgreSQL, Redis | S3 | Lessons, user progress, gamification |
| **Udemy** | PostgreSQL, MongoDB | Redis, Elasticsearch | Courses, videos, student data |

### Communication

| Website/App | Primary Database Technology | Additional Data Stores | Purpose |
|-------------|----------------------------|------------------------|---------|
| **WhatsApp** | MySQL (sharded), Mnesia | Memcached | Messages, user profiles, groups |
| **Telegram** | MySQL (custom sharding) | Memcached | Messages, channels, media |
| **Signal** | PostgreSQL, Redis | S3 | Encrypted messages, contacts |
| **WeChat** | MySQL, Cassandra | Redis, HBase | Messages, payments, mini-programs |

---

## Key Insights

### Database Selection Factors

1. **Data Structure**: Relational vs. Document vs. Graph vs. Key-Value
2. **Scalability Needs**: Vertical vs. Horizontal scaling requirements
3. **Consistency Requirements**: ACID vs. BASE, CAP theorem considerations
4. **Read/Write Patterns**: Read-heavy vs. Write-heavy workloads
5. **Latency Requirements**: Real-time vs. Batch processing
6. **Cost Considerations**: Licensing, infrastructure, and operational costs
7. **Developer Expertise**: Team familiarity with specific technologies
8. **Compliance Requirements**: Data residency, encryption, audit trails

### Common Patterns

- **Polyglot Persistence**: Using multiple database types for different use cases
- **Caching Layer**: Redis/Memcached for frequently accessed data
- **Search Layer**: Elasticsearch for full-text search capabilities
- **Data Warehousing**: Redshift/BigQuery/Snowflake for analytics
- **Message Queues**: Kafka/RabbitMQ for event-driven architectures
- **Object Storage**: S3/GCS/Azure Blob for unstructured data

### Recent Technology Shifts

1. **From Monolithic to Microservices**: Database per service pattern
2. **From Self-Hosted to Managed Services**: Reduced operational burden
3. **From SQL-Only to Polyglot**: Multiple database types in one application
4. **From Batch to Real-Time**: Stream processing and real-time analytics
5. **From Single-Region to Global**: Distributed databases with multi-region replication
6. **From Manual to Automated**: AI-driven database management and optimization

---

## References

1. [DB-Engines Ranking](https://db-engines.com/en/ranking) - Database Popularity Trends
2. [Stack Overflow Developer Survey 2024](https://survey.stackoverflow.co/) - Most Used Databases
3. [AWS Architecture Blog](https://aws.amazon.com/blogs/architecture/) - Cloud Database Patterns
4. [High Scalability](http://highscalability.com/) - Architecture Deep Dives
5. [Google Research Papers](https://research.google/pubs/) - Database Innovation
6. [Martin Fowler's Blog](https://martinfowler.com/) - Database Design Patterns
7. [The Morning Paper](https://blog.acolyer.org/) - Database Research Summaries
8. Company Engineering Blogs:
   - [Netflix Tech Blog](https://netflixtechblog.com/)
   - [Uber Engineering](https://eng.uber.com/)
   - [Airbnb Engineering](https://medium.com/airbnb-engineering)
   - [Meta Engineering](https://engineering.fb.com/)
   - [LinkedIn Engineering](https://engineering.linkedin.com/)

---

## Questions to Consider

1. What are the trade-offs between consistency and availability in distributed databases?
2. How do NoSQL databases differ from traditional relational databases?
3. What is the CAP theorem and how does it influence database design?
4. Why do many large companies use multiple database technologies (polyglot persistence)?
5. What role do caching layers play in modern database architectures?
6. How are vector databases different from traditional databases?
7. What are the environmental impacts of database operations and how can they be minimized?
8. How do serverless databases change the cost model compared to traditional databases?

---

## Lab Exercise

1. Research and identify the database technology used by your three favorite websites or mobile apps
2. Create a comparison table showing:
   - Application name
   - Type of application (social media, e-commerce, etc.)
   - Primary database technology
   - Reasons for choosing that particular database
   - Scale of operations (number of users, data size)
3. Prepare a short presentation (5 minutes) on current database trends
4. Discuss how green computing principles can be applied to database management

---

*This practical provides foundational knowledge about modern database technologies and their real-world applications. Understanding these trends is essential for making informed decisions in database design and implementation.*
