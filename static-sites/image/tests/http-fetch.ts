import * as Http from 'http'
import { StartedTestContainer } from 'testcontainers'

/**
 * I tried to make fetch happen, but I stopped and used this instead
 * 
 * ...because fetch couldn't fake a `Host` header.
 */
export interface FakeFetchResponse {
    raw: Http.IncomingMessage
    status?: number
    statusText?: string
    ok: boolean
    url: string
    text(): Promise<string>
}
async function httpRequestRaw(url: string | URL, options?: Http.RequestOptions): Promise<Http.IncomingMessage> {
    return await new Promise((resolve, reject) => {
        Http.request(url, options ?? {}, resolve)
            .on('error', reject)
            .end()
    })
}
async function httpBodyText(res: Http.IncomingMessage): Promise<string> {
    return new Promise((resolve, reject) => {
        const chunks: string[] = []
        res.setEncoding('utf8')
        res.on('data', chunk => chunks.push(chunk))
        res.on('end', () => resolve(chunks.join()))
        res.on('error', reject)
    })
}

/**
 * Mimic the parts I need from `fetch`, and add fake `Host` headers
 */
export async function httpRequest(url0: string | URL, options?: Http.RequestOptions): Promise<FakeFetchResponse> {
    const raw = await httpRequestRaw(url0, options)
    const status = raw.statusCode
    const statusText = raw.statusMessage
    const ok = raw.statusCode != null && raw.statusCode >= 200 && raw.statusCode < 300
    const url = raw.url ?? url0.toString()
    function text() {
        return httpBodyText(raw)
    }
    return { raw, status, statusText, ok, url, text }
}
export async function httpRequestWithHost(url: string | URL, Host: string, options?: Http.RequestOptions): Promise<FakeFetchResponse> {
    options = options ?? {}
    options.headers = { ...(options.headers ?? {}), Host }
    return httpRequest(url, options)
}

export function containerOrigin(container: StartedTestContainer): string {
    return `http://${container.getHost()}:${container.getFirstMappedPort()}`
}
export async function containerHttpRequest(container: StartedTestContainer, url: string | URL, options?: Http.RequestOptions): Promise<FakeFetchResponse> {
    const u = new URL(url)
    const { host } = u
    // console.log('containerHttpRequest', { host })

    const origin = new URL(containerOrigin(container))
    u.host = origin.host
    u.protocol = origin.protocol
    // console.log('containerHttpRequest', { host, u })
    return httpRequestWithHost(u, host, options)
}