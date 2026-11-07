# paperclip

A container image for the paperclip ai.

## Migration

```
kubectl exec -n ai deploy/paperclip -- node \
      /usr/lib/node_modules/paperclipai/node_modules/@paperclipai/db/dist/migrate.js
```
