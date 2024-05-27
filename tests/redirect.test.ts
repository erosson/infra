import { expect, test } from 'vitest'

interface RedirectData {
    to: string
    from: string
    status?: number
}
const redirects: readonly RedirectData[] = [
    ...selfRedirect('erosson.org'),
    ...selfRedirect404('erosson.org'),
    ...domainRedirect('erosson.org', 'erosson.com'),
    ...domainRedirect404('erosson.org', 'erosson.com'),
    ...domainRedirect('erosson.org', 'evanrosson.com'),
    ...domainRedirect404('erosson.org', 'evanrosson.com'),
    ...domainRedirect('erosson.org', 'evanrosson.org'),
    ...domainRedirect404('erosson.org', 'evanrosson.org'),
    ...domainRedirect('erosson.org', 'erosson.us'),
    ...domainRedirect404('erosson.org', 'erosson.us'),

    ...selfRedirect('swarmsim.com'),
    // ...selfRedirect404('swarmsim.com'),
    ...domainRedirect('swarmsim.com', 'swarmsimulator.com'),
    // ...domainRedirect404('swarmsim.com', 'swarmsimulator.com'),

    ...domainRedirect('warswarms.com', 'war-swarms.com'),
    ...domainRedirect404('warswarms.com', 'war-swarms.com'),
    ...domainRedirect('warswarms.com', 'warswarm.com'),
    ...domainRedirect404('warswarms.com', 'warswarm.com'),

    ...selfRedirect('zealgame.com'),
]

/**
 * Verify "http://example.com", "http://www.example.com", and "https://example.com" all redirect to "https://www.example.com"
 */
function selfRedirect(domain: string): readonly RedirectData[] {
    const to = `https://www.${domain}/`
    return [
        { to, from: `http://www.${domain}/` },
        { to, from: `http://${domain}/` },
        { to, from: `https://${domain}/` },
    ]
}
function selfRedirect404(domain: string): readonly RedirectData[] {
    const to = `https://www.${domain}/`
    const to404 = `${to.replace(/\/$/, '')}/404`
    return [
        { to: to404, status: 404, from: `http://www.${domain}/404` },
        { to: to404, status: 404, from: `http://${domain}/404` },
        { to: to404, status: 404, from: `https://${domain}/404` },
    ]
}

function domainRedirect(toDomain: string, from: string): readonly RedirectData[] {
    const to = `https://www.${toDomain}/`
    return [
        { to, from: `http://${from}/` },
        { to, from: `http://www.${from}/` },
        { to, from: `https://${from}/` },
        { to, from: `https://www.${from}/` },
    ]
}
function domainRedirect404(toDomain: string, from: string): readonly RedirectData[] {
    const to = `https://www.${toDomain}/`
    const to404 = `${to.replace(/\/$/, '')}/404`
    return [
        { to: to404, status: 404, from: `http://${from}/404` },
        { to: to404, status: 404, from: `http://www.${from}/404` },
        { to: to404, status: 404, from: `https://${from}/404` },
        { to: to404, status: 404, from: `https://www.${from}/404` },
    ]
}

for (const r of redirects) {
    test(`${r.to} <- ${r.from}`, async () => {
        const res = await fetch(r.from, { redirect: 'follow' })
        expect(res.status).toBe(r.status ?? 200)
        expect(res.url).toBe(r.to)
    })
}
