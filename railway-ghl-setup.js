// Railway + GHL Setup Script
// Run with: railway run node railway-ghl-setup.js

const axios = require('axios');

// GHL PIT token should be in Railway environment variables
const GHL_PIT_TOKEN = process.env.GHL_PIT_TOKEN;
const GHL_LOCATION_ID = process.env.GHL_LOCATION_ID || '';

if (!GHL_PIT_TOKEN) {
  console.error('❌ GHL_PIT_TOKEN not found in environment variables');
  console.error('Please set GHL_PIT_TOKEN in Railway environment variables');
  process.exit(1);
}

const GHL_API_BASE = 'https://rest.gohighlevel.com/v1';

const ghlClient = axios.create({
  baseURL: GHL_API_BASE,
  headers: {
    'Authorization': `Bearer ${GHL_PIT_TOKEN}`,
    'Content-Type': 'application/json',
    'Version': '2021-07-28'
  }
});

async function setupGHLCourse() {
  console.log('🚀 Starting GHL Course Setup...');
  
  try {
    // 1. Test connection
    console.log('🔌 Testing GHL connection...');
    const testResponse = await ghlClient.get('/locations');
    console.log('✅ GHL connection successful');
    
    // 2. Create custom fields for course tracking
    console.log('📝 Creating custom fields...');
    const customFields = [
      {
        name: 'course_progress',
        fieldType: 'text',
        label: 'Course Progress',
        description: 'Modules completed (e.g., "Module 1, Module 2")'
      },
      {
        name: 'last_module_completed',
        fieldType: 'text',
        label: 'Last Module Completed',
        description: 'Most recent module finished'
      },
      {
        name: 'course_start_date',
        fieldType: 'date',
        label: 'Course Start Date',
        description: 'When student started the course'
      },
      {
        name: 'course_completion_date',
        fieldType: 'date',
        label: 'Course Completion Date',
        description: 'When student completed all modules'
      }
    ];
    
    for (const field of customFields) {
      try {
        await ghlClient.post('/custom-fields', field);
        console.log(`✅ Created field: ${field.label}`);
      } catch (error) {
        if (error.response?.status === 409) {
          console.log(`⚠️ Field already exists: ${field.label}`);
        } else {
          console.log(`⚠️ Could not create field ${field.label}:`, error.message);
        }
      }
    }
    
    // 3. Create tags
    console.log('🏷️ Creating course tags...');
    const tags = [
      'AI Course Member',
      'Module 1 Complete',
      'Module 2 Complete',
      'Module 3 Complete',
      'Module 4 Complete',
      'Module 5 Complete',
      'Module 6 Complete',
      'Course Completed',
      'Need Support',
      'Active Student'
    ];
    
    for (const tagName of tags) {
      try {
        await ghlClient.post('/tags', { name: tagName });
        console.log(`✅ Created tag: ${tagName}`);
      } catch (error) {
        if (error.response?.status === 409) {
          console.log(`⚠️ Tag already exists: ${tagName}`);
        } else {
          console.log(`⚠️ Could not create tag ${tagName}:`, error.message);
        }
      }
    }
    
    // 4. Create payment link (if API supports it)
    console.log('💳 Setting up payment link...');
    console.log('ℹ️ Note: Payment links often need to be created in GHL UI');
    console.log('📋 Manual steps:');
    console.log('1. Go to GHL → Payments → Payment Links');
    console.log('2. Create new link:');
    console.log('   - Name: "AI Automation Mastery Course"');
    console.log('   - Price: $97');
    console.log('   - Product: "AI Automation Mastery Course"');
    console.log('3. Copy the payment link URL');
    
    // 5. Create community/group (if API supports it)
    console.log('👥 Setting up community...');
    console.log('ℹ️ Note: Communities often need UI setup');
    console.log('📋 Manual steps:');
    console.log('1. Go to GHL → Communities/Groups');
    console.log('2. Create new: "AI Automation Mastery Community"');
    console.log('3. Set access: Paid/Private');
    console.log('4. Connect to payment link');
    
    console.log('\n🎉 GHL Course Setup Complete!');
    console.log('\n📋 Next Steps:');
    console.log('1. Create payment link in GHL UI');
    console.log('2. Create community in GHL UI');
    console.log('3. Build funnel pages in GHL');
    console.log('4. Set up email sequences');
    console.log('5. Create automations/workflows');
    
    console.log('\n🔗 Resources created:');
    console.log('- Custom fields for course tracking');
    console.log('- Tags for student management');
    console.log('- API connection verified');
    
  } catch (error) {
    console.error('❌ Setup failed:', error.message);
    if (error.response) {
      console.error('Response:', error.response.data);
    }
    process.exit(1);
  }
}

// Run setup
setupGHLCourse();