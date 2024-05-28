import * as Path from 'path'
import { GenericContainer, StartedTestContainer } from 'testcontainers'
import { beforeAll, expect, test } from 'vitest'
import { containerHttpRequest, containerOrigin, httpRequest, httpRequestWithHost } from './http-fetch'

let container: StartedTestContainer

beforeAll(async () => {
    const dockerCtx = Path.join(__dirname, "..")
    // const image = await GenericContainer.fromDockerfile(dockerCtx).withBuildArgs({ NO_LOCALHOST: '1' }).build()
    const image = await GenericContainer.fromDockerfile(dockerCtx).build()
    container = await image.withEnvironment({ 'DOMAIN_PREFIX': 'http://' }).withExposedPorts(80).start()
}, 90000)
function origin() {
    return containerOrigin(container)
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
test('vhost containerHttpRequest docker-ops.erosson.org', async () => {
    const res = await containerHttpRequest(container, 'http://docker-ops.erosson.org')
    const body = await res.text()
    expect(body).not.toContain('no vhost')
    expect(body).toContain('docker-ops.erosson.org')
})

test('render www.erosson.org', async () => {
    const res = await containerHttpRequest(container, 'http://www.erosson.org')
    const body = await res.text()
    expect(body).not.toContain('no vhost')
    expect(body).toContain('Evan Rosson')
    expect(body).toContain("https://mastodon.social/@erosson")
})
test('render www.swarmsim.com', async () => {
    const res = await containerHttpRequest(container, 'http://www.swarmsim.com')
    const body = await res.text()
    expect(body).not.toContain('no vhost')
    expect(body).toContain('Swarm Simulator')
})

export interface RedirectData {
    to: string
    from: string
}
export const redirects: readonly RedirectData[] = [
    { to: 'https://www.erosson.org/', from: 'http://erosson.org' },
    { to: 'https://www.erosson.org/', from: 'http://erosson.com' },
    { to: 'https://www.erosson.org/', from: 'http://www.erosson.com' },
    { to: 'https://www.erosson.org/', from: 'http://erosson.us' },
    { to: 'https://www.erosson.org/', from: 'http://www.erosson.us' },
    { to: 'https://www.erosson.org/', from: 'http://evanrosson.com' },
    { to: 'https://www.erosson.org/', from: 'http://www.evanrosson.com' },
    { to: 'https://www.erosson.org/', from: 'http://evanrosson.org' },
    { to: 'https://www.erosson.org/', from: 'http://www.evanrosson.org' },
    { to: 'https://www.swarmsim.com/', from: 'http://swarmsim.com' },
    { to: 'https://www.swarmsim.com/', from: 'http://swarmsimulator.com' },
    { to: 'https://www.swarmsim.com/', from: 'http://www.swarmsimulator.com' },
    { to: 'https://www.warswarms.com/', from: 'http://warswarms.com' },
    { to: 'https://www.warswarms.com/', from: 'http://war-swarms.com' },
    { to: 'https://www.warswarms.com/', from: 'http://www.war-swarms.com' },
    { to: 'https://www.warswarms.com/', from: 'http://warswarm.com' },
    { to: 'https://www.warswarms.com/', from: 'http://www.warswarm.com' },
    { to: 'https://www.zealgame.com/', from: 'http://zealgame.com' },
]

for (const r of redirects) {
    test(`local redirect: ${r.to} <- ${r.from}`, async () => {
        const res = await containerHttpRequest(container, r.from)
        expect(res.status).toBe(302)
        expect(res.raw.headers.location).toBe(r.to)
    })
}