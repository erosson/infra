import * as Path from 'path'
import { GenericContainer, StartedTestContainer } from 'testcontainers'
import { beforeAll, expect, test } from 'vitest'
import { httpRequest, httpRequestWithHost } from './http-fetch'

let container: StartedTestContainer

beforeAll(async () => {
    const dockerCtx = Path.join(__dirname, "..")
    // const image = await GenericContainer.fromDockerfile(dockerCtx).withBuildArgs({ NO_LOCALHOST: '1' }).build()
    const image = await GenericContainer.fromDockerfile(dockerCtx).build()
    container = await image.withEnvironment({ 'DOMAIN_PREFIX': 'http://' }).withExposedPorts(80).start()
}, 90000)
function origin() {
    return `http://${container.getHost()}:${container.getFirstMappedPort()}`
}

test('no vhost, via fetch', async () => {
    const res = await fetch(origin())
    const body = await res.text()
    expect(body).toContain('no vhost')
})
test('no vhost', async () => {
    const res = await httpRequest(origin())
    expect(await res.text()).toContain('no vhost')
})
test('bogus vhost', async () => {
    const res = await httpRequestWithHost(origin(), 'nope-nothing-here-fjkklfdsjklf.erosson.org')
    expect(await res.text()).toContain('no vhost')
})
test('vhost docker-ops.erosson.org', async () => {
    // const res = await fetch(origin(), { redirect: 'follow', headers: { Host: 'docker-ops.erosson.org' } })
    // NOPE. https://stackoverflow.com/questions/43285286/can-you-set-the-host-header-using-fetch-api
    const res = await httpRequestWithHost(origin(), 'docker-ops.erosson.org')
    const body = await res.text()
    expect(body).not.toContain('no vhost')
    expect(body).toContain('docker-ops.erosson.org')
})