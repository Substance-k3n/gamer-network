# apps/mobile — Flutter app (Android first)

Owner: Natnael Sisay (@Natnsis). The product (ADR-0002).

Not scaffolded yet. Create it with:

```bash
flutter create --org <reverse-domain> --project-name gamer_network --platforms android,ios .
```

The API client is generated from `packages/api-spec/openapi.json`; don't
hand-write request/response models. Screens follow the prototype
("rally"), minus the Home feed (ADR-0001).
