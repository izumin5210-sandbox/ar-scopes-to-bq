``````
:) % bin/rails r gen_scope_doc.rb 2> /dev/null
## `User`
### default

```sql
SELECT `rdb.users`.* FROM `rdb.users` WHERE `rdb.users`.`deleted` = false
```

### `only_deleted`


```sql
SELECT `rdb.users`.* FROM `rdb.users` WHERE (users.`deleted` IS NULL OR users.`deleted` != false)
```

### `without_deleted`


```sql
SELECT `rdb.users`.* FROM `rdb.users` WHERE `rdb.users`.`deleted` = false AND `rdb.users`.`deleted` = false
```

### `with_deleted`


```sql
SELECT `rdb.users`.* FROM `rdb.users`
```

### `registered`
Lists registered users.

```sql
SELECT `rdb.users`.* FROM `rdb.users` WHERE `rdb.users`.`deleted` = false AND `rdb.users`.`registered` = true
```
``````
