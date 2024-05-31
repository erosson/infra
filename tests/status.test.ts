import { expect, test } from 'vitest'

interface StatusCheck {
    url: string
    status?: number
}
const checks: readonly StatusCheck[] = [
    { url: 'https://math2.swarmsim.com' },
    { url: 'https://math.swarmsim.com' },
    { url: 'https://www.swarmsim.com' },
    { url: 'https://preprod.swarmsim.com' },
    { url: 'https://elm.swarmsim.com' },
    { url: 'https://www.zealgame.com' },
    { url: 'https://www.erosson.org' },
    { url: 'https://cooking.erosson.org' },
    { url: 'https://ops.erosson.org' },
    { url: 'https://freecbt.erosson.org' },
    { url: 'https://vegas-wordle.erosson.org' },
    { url: 'https://ch2.erosson.org' },
    { url: 'https://mapwatch.erosson.org' },
    { url: 'https://piano.erosson.org' },
    { url: 'https://travel.erosson.org' },
    { url: 'https://wheres.erosson.org' },
    { url: 'https://wolcendb.erosson.org' },
]

for (const c of checks) {
    test(`${c.url}: ${c.status ?? 200}`, async () => {
        const res = await fetch(c.url, { redirect: 'error' })
        expect(res.status).toBe(c.status ?? 200)
    })
}
