local log = require "log"

log.set(log.DEBUG)
log.debug("hello"," debug")
log.info("hello"," info")
log.warn("hello"," warn")
log.error("hello"," error")

log.set(log.INFO)
log.debug("hello"," debug")
log.info("hello"," info")
log.warn("hello"," warn")
log.error("hello"," error")

log.set(log.WARN)
log.debug("hello"," debug")
log.info("hello"," info")
log.warn("hello"," warn")
log.error("hello"," error")

log.set(log.ERROR)
log.debug("hello"," debug")
log.info("hello"," info")
log.warn("hello"," warn")
log.error("hello"," error")


