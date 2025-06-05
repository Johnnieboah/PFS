import requests
from bs4 import BeautifulSoup
import json
from datetime import datetime
import time

def scrape_nfl_depth_charts():
    print("🏈 Starting NFL depth chart scraper...")
    
    url = "https://www.ourlads.com/nfldepthcharts/depthcharts.aspx"
    
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }
    
    try:
        print("📡 Fetching data from ourlads.com...")
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Create JSON structure
        nfl_data = {
            "metadata": {
                "scraped_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                "source": "ourlads.com/nfldepthcharts",
                "status": "success"
            },
            "teams": {}
        }
        
        print("🔍 Parsing HTML for team data...")
        
        # Look for team links and data
        team_links = soup.find_all('a', href=True)
        tables = soup.find_all('table')
        
        print(f"Found {len(team_links)} links and {len(tables)} tables")
        
        # Extract any team-related content
        team_content = []
        for link in team_links:
            href = link.get('href', '')
            text = link.get_text(strip=True)
            
            # Look for NFL team patterns
            if any(team in text.lower() for team in ['chiefs', 'cowboys', 'patriots', 'packers', 'ravens', 'steelers']):
                team_content.append({
                    'name': text,
                    'url': href,
                    'type': 'link'
                })
        
        # Process tables for depth chart data
        for i, table in enumerate(tables):
            rows = table.find_all('tr')
            if len(rows) > 1:  # Has header and data
                table_data = []
                for row in rows:
                    cells = row.find_all(['td', 'th'])
                    row_data = [cell.get_text(strip=True) for cell in cells]
                    if row_data:
                        table_data.append(row_data)
                
                if table_data:
                    nfl_data["teams"][f"table_{i}"] = {
                        "data": table_data,
                        "type": "table_data"
                    }
        
        # Add found team content
        for i, team in enumerate(team_content):
            nfl_data["teams"][f"team_{i}"] = team
        
        nfl_data["metadata"]["teams_found"] = len(team_content)
        nfl_data["metadata"]["tables_found"] = len(tables)
        
        return nfl_data
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return {
            "metadata": {
                "scraped_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                "source": "ourlads.com",
                "status": "error",
                "error": str(e)
            },
            "teams": {}
        }

def save_json(data, filename="nfl_depth_charts.json"):
    try:
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"✅ Data saved to {filename}")
        return True
    except Exception as e:
        print(f"❌ Error saving file: {e}")
        return False

def main():
    print("=" * 50)
    print("🏈 NFL DEPTH CHART SCRAPER")
    print("=" * 50)
    
    # Scrape the data
    data = scrape_nfl_depth_charts()
    
    # Save to JSON
    if save_json(data):
        print("\n📊 SUMMARY:")
        print(f"   Status: {data['metadata']['status']}")
        print(f"   Teams found: {data['metadata'].get('teams_found', 0)}")
        print(f"   Tables found: {data['metadata'].get('tables_found', 0)}")
        print(f"   Scraped at: {data['metadata']['scraped_at']}")
        print(f"   File: nfl_depth_charts.json")
        
        # Show first few entries
        if data['teams']:
            print(f"\n🔍 PREVIEW:")
            for key, value in list(data['teams'].items())[:3]:
                print(f"   {key}: {str(value)[:100]}...")
    
    print("\n🎉 Done! Check nfl_depth_charts.json for your data.")

if __name__ == "__main__":
    main()
