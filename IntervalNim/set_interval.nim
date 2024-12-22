import system
import math

proc add_up*[T](x, y: T): T =
    x + y

proc add_down*[T](x, y: T): T =
    x + y

proc sub_up*[T](x, y: T): T =
    x - y

proc sub_down*[T](x, y: T): T =
    x - y

proc mul_up*[T](x, y: T): T =
    x * y

proc mul_down*[T](x, y: T): T =
    x * y

proc div_up*[T](x, y: T): T =
    x / y

proc div_down*[T](x, y: T): T =
    x / y

proc sqrt_up*[T](x: T): T =
    sqrt(x)

proc sqrt_down*[T](x: T): T =
    sqrt(x)

proc interval_begin*[T](x: T) =
    discard

proc interval_end*[T](x: T) = 
    discard