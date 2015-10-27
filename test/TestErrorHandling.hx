import utest.Assert;

import abe.error.*;
import express.*;
using thx.Strings;

class TestErrorHandling extends TestCalls {
  public function testBasicHttpError() {
    app.router.register(new ErrorMaker());
    app.router.error(abe.mw.ErrorHandler.handle);

    get("/badrequest", function (msg, res) {
      Assert.equals("Bad Request", msg);
      Assert.equals(400, res.statusCode);
    });

    get("/unauthorized", function (msg, res) {
      Assert.equals("Must be logged in", msg);
      Assert.equals(401, res.statusCode);
    });

    get("/forbidden", function (msg, res) {
      Assert.equals("Forbidden", msg);
      Assert.equals(403, res.statusCode);
    });

    get("/notfound", function (msg, res) {
      Assert.isTrue(msg.startsWith("Resource"));
      Assert.equals(404, res.statusCode);
    });

    get("/teapot/coffee", function (_, res) {
      Assert.equals(418, res.statusCode);
    });

    get("/completely/missing", function (_, res) {
      Assert.equals(404, res.statusCode);
    });
  }
}

class ErrorMaker implements abe.IRoute {
  @:get("/badrequest")
  function badRequest() {
    next.error(new BadRequestError());
  }

  @:get("/unauthorized")
  function unauthorized() {
    next.error(new UnauthorizedError("Must be logged in"));
  }

  @:get("/forbidden")
  function forbidden() {
    next.error(new ForbiddenError());
  }

  @:get("/notfound")
  function notFound() {
    next.error(new NotFoundError("Resource Not Found"));
  }

  @:get("/teapot/coffee")
  function teapot() {
    next.error(new BaseHttpError("I'm a teapot", 418));
  }
}
