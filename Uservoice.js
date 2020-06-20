const puppeteer = require('puppeteer');
const fs = require('fs');
const text = fs.readFileSync('./Voice.txt',{encoding:'utf8', flag:'r'},).split('\n');
let browser = {}
let context = {}
const sleep = t => {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve();
    }, t)
  })
};

const browserInit = async() => {
  browser = await puppeteer.launch({
    headless: false,
  })

  context = await browser.createIncognitoBrowserContext();
}

const browserDestroy = async() => {
  browser.close();  
}

const pageExploration = async(email) => {
  try {
    await browserInit()
    const page = await context.newPage()

    page.setViewport({
      height: 800,
      width: 1000,
    });
  
    await sleep(3000);
    await page.goto('https://microsoftteams.uservoice.com/forums/555103-public/suggestions/18895894-allow-global-admin-to-be-able-to-see-all-teams-or');
  
    await page.waitForSelector('[class="uvIdeaVoteFormTriggerState-no_votes uvStyle-button"]')
    await page.click('[class="uvIdeaVoteFormTriggerState-no_votes uvStyle-button"]');
    
    await page.waitForSelector('[title="Your email address"]')
    await page.focus('[title="Your email address"]')
    await page.keyboard.type(email||'')
    await sleep(300);

    await page.waitForSelector('[class="uvIdeaVoteButton uvFieldEtc-submit-button uvStyle-button"]')
    await page.click('[class="uvIdeaVoteButton uvFieldEtc-submit-button uvStyle-button"]');
    await sleep(5000);
    await page.close()

    await browserDestroy()
  
  } catch (error) {
    console.log(error)
  }  
}


(async() => {
  
  for (const element of text) {
    console.log(element)
  
    await pageExploration(element) 
  }
})();