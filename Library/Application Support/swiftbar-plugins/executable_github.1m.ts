#!/opt/homebrew/bin/bun
import { graphql } from '@octokit/graphql'
import { formatDistanceToNow } from 'date-fns'
import dotenv from 'dotenv'
import _ from 'lodash'
import xbar, { Options, separator } from 'xbar'

dotenv.config({ path: __dirname + '/.env' })

const main = async () => {
  const {
    search: { edges: pullRequests },
  } = (await graphql(
    `
      {
        search(
          first: 100
          query: "-author:@me -author:app/dependabot -author:app/renovate is:open team-review-requested:supabase/infra-v3 type:pr"
          type: ISSUE
        ) {
          edges {
            node {
              ... on PullRequest {
                author {
                  login
                }
                body
                createdAt
                files(first: 100) {
                  edges {
                    node {
                      additions
                      changeType
                      deletions
                      path
                    }
                  }
                }
                number
                repository {
                  nameWithOwner
                }
                title
                updatedAt
                url
              }
            }
          }
          issueCount
        }
      }
    `,
    {
      headers: {
        authorization: `token ${process.env.GITHUB_PERSONAL_ACCESS_TOKEN}`,
      },
    }
  )) as {
    search: {
      edges: {
        node: {
          author: {
            login: string
          }
          body: string
          createdAt: string
          files: {
            edges: {
              node: {
                additions: number
                changeType: 'ADDED' | 'CHANGED' | 'COPIED' | 'DELETED' | 'MODIFIED' | 'RENAMED'
                deletions: number
                path: string
              }
            }[]
          }
          number: number
          repository: {
            nameWithOwner: string
          }
          title: string
          updatedAt: string
          url: string
        }
      }[]
    }
  }

  const oneWeekAgo = new Date()
  oneWeekAgo.setDate(oneWeekAgo.getDate() - 7)

  const relevantPRs = _.orderBy(
    pullRequests.filter(
      ({
        node: {
          files: { edges: fileEdges },
          title,
          updatedAt,
        },
      }) =>
        new Date(updatedAt) > oneWeekAgo &&
        (title.includes('hotfix') ||
          _.sumBy(fileEdges, 'node.additions') < 10 ||
          !fileEdges.every(({ node: { path } }) => path.startsWith('api/')))
    ),
    'node.updatedAt',
    'desc'
  )

  if (!process.env.SWIFTBAR) {
    console.log(JSON.stringify(relevantPRs, null, 2))
  }

  const menuItems: Array<(Options & { md: boolean }) | typeof separator> = []

  for (const {
    node: {
      author: { login },
      body,
      createdAt,
      files: { edges: fileEdges },
      number,
      repository: { nameWithOwner },
      title,
      updatedAt,
      url,
    },
  } of relevantPRs) {
    const files = _.map(fileEdges, 'node')

    menuItems.push({
      href: url,
      md: true,
      text: `**${title}** \n\n${body
        .replace(/(\r\n)+/g, '\n')
        .replace(/\s+$/g, '')
        .split('\n')
        .slice(0, 10)
        .join('\n')}\n`,
    })
    menuItems.push({
      href: `${url}/files`,
      md: true,
      submenu: files.map(({ additions, changeType, deletions, path }) => ({
        href: `${url}/files`,
        text: `${changeType === 'CHANGED' ? 'T' : changeType[0]
          } ${path} (+${additions} -${deletions})`,
      })),
      text: `*${nameWithOwner}#${number} opened ${formatDistanceToNow(createdAt, {
        addSuffix: true,
      })} by ${login} • updated ${formatDistanceToNow(updatedAt, {
        addSuffix: true,
      })} • ${files.length} file${files.length > 1 ? 's' : ''} changed (+${+_.sumBy(
        files,
        'additions'
      )} -${_.sumBy(files, 'deletions')})*`,
    })
    menuItems.push(separator)
  }

  xbar([
    {
      text: `${relevantPRs.length} PRs`,
    },
    separator,
    ...menuItems,
  ])
}

void main()
