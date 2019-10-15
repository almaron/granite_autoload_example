# README

This is a demonstration of a problem I encountered while working with `granite` gem. 

It includes 1 model, stubbed authentication and authorization, 1 BA and 1 projector that is used by that BA. 

### Steps to reproduce the issue.

1. Set up the app, create and migrate the database.
2. Run the dev server, visit the root path, click `Create User`.
3. Introduce any change (controller, action, model, etc) and try to reload the page.
4. See error
```txt
ArgumentError at /user/create
A copy of AuthenticatableController has been removed from the module tree but is still active!
```
