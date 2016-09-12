# Authentication
Doorkeeper::Application.create id: 'd420c30d-91ed-4003-8942-415d764ea4bd',
                               uid: '56e31494cc38e927ca0c55594f47996ceb60873e27119ed56fed79de9505cd6a',
                               secret: '0a117b0e9885eebec61d9b9a163508c0f8e0ea66359e8bb020f7aecbc9f25e7d',
                               name: 'Admin',
                               redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
                               scopes: ''

User.new(email: 'admin@example.com', password: 'password').save(validate: false)

# Creating the available locations

# Berlin
region = Region.create name: 'Berlin', country: 'Germany', slug: 'berlin', sender_email: 'appointments@letsintegrate.de'
Location.create name: 'Altstadt Spandau', slug: 'altstadt-spandau'
Location.create name: 'U-Bhf Rathaus Schöneberg', slug: 'rathaus-schoeneberg'
Location.create name: 'S+U Schönhauser Allee', slug: 'schoenhauser-allee'
Location.create name: 'Treptower Park', slug: 'treptower-park'
Location.create name: 'Weltzeituhr am Alexanderplatz', slug: 'alexanderplatz'
Location.create name: 'Bikinihaus am Zoologischen Garten', slug: 'zoologischer-garten'
