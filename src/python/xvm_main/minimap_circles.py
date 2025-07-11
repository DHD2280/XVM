"""
SPDX-License-Identifier: GPL-3.0-or-later
Copyright (c) 2013-2025 XVM Contributors
Copyright (c) Omegaice
"""

def getMinimapCirclesData():
    return _g_minimap_circles.minimapCirclesData

def setMinimapCirclesData(value):
    _g_minimap_circles.setMinimapCirclesData(value)

def updateCurrentVehicle():
    _g_minimap_circles.updateCurrentVehicle()


# PRIVATE

import math
import traceback

from CurrentVehicle import g_currentVehicle
from helpers import dependency
from skeletons.gui.shared import IItemsCache

from xfw import *
from logger import *
import userprefs


class _MinimapCircles(object):

    itemsCache = dependency.descriptor(IItemsCache)

    def __init__(self):
        self.clear()

    def clear(self):
        self.minimapCirclesData = None
        self.vehicleItem = None
        self.crew = []
        self.is_full_crew = False
        self.view_distance_vehicle = 0
        self.base_commander_skill = 100.0
        self.base_radioman_skill = 0.0
        self.base_loaders_skill = 0.0
        self.brothers_in_arms = False
        self.stereoscope = False
        self.ventilation = False
        self.coated_optics = False
        self.rammer = False
        self.consumable = False
        self.commander_sixthSense = False
        self.commander_eagleEye = 0.0
        self.radioman_finder = 0.0
        self.radioman_inventor = 0.0
        self.camouflage = []

    def setMinimapCirclesData(self, value):
        self.minimapCirclesData = value

    def updateCurrentVehicle(self):
        # debug('updateCurrentVehicle')

        self.clear()

        # debug(g_currentVehicle)
        # debug(g_currentVehicle.item)
        self.vehicleItem = g_currentVehicle.item
        if self.vehicleItem is None:
            return

        self.view_distance_vehicle = self.vehicleItem.descriptor.turret.circularVisionRadius
        #debug('  view_distance_vehicle: %.0f' % self.view_distance_vehicle)

        self._updateCrew()
        crewRoles_arr = self.vehicleItem.descriptor.type.crewRoles # roles per position in vehicle

        # Search skills and Brothers In Arms
        self.brothers_in_arms = True
        self.camouflage = []
        loaders_count = 0
        male_count = 0
        female_count = 0

        for crew_item in self.crew:
            name = crew_item['name']
            data = crew_item['data']
            skills = data['skill']
            position = data['position'] # position in vehicle

            if 'commander' in crewRoles_arr[position]:
                self.base_commander_skill = data['level']
                self.commander_sixthSense = skills.get('commander_sixthSense', -1) == 100
                if self.commander_eagleEye < skills.get('commander_eagleEye', -1):
                    self.commander_eagleEye = skills['commander_eagleEye']

            if 'radioman' in crewRoles_arr[position]:
                skill = data['level']
                if self.base_radioman_skill < skill:
                    self.base_radioman_skill = skill
                if self.radioman_finder < skills.get('radioman_finder', -1):
                    self.radioman_finder = skills['radioman_finder']
                if self.radioman_inventor < skills.get('radioman_inventor', -1):
                    self.radioman_inventor = skills['radioman_inventor']

            if 'loader' in crewRoles_arr[position]:
                self.base_loaders_skill += data['level']
                loaders_count += 1

            self.camouflage.append({'name': name, 'skill': skills.get('camouflage', 0)})

            if data['isFemale']:
                female_count += 1
            else:
                male_count += 1
            if skills.get('brotherhood', -1) != 100:
                self.brothers_in_arms = False

        if loaders_count > 1:
            self.base_loaders_skill /= loaders_count
        if male_count > 0 and female_count > 0:
            self.brothers_in_arms = False

        #debug('  base_commander_skill: %.0f' % self.base_commander_skill)
        #debug('  base_radioman_skill: %.0f' % self.base_radioman_skill)
        #debug('  base_loaders_skill: %.0f' % self.base_loaders_skill)
        #debug('  commander_sixthSense: %d' % self.commander_sixthSense)
        #debug('  commander_eagleEye: %d' % self.commander_eagleEye)
        #debug('  radioman_finder: %d' % self.radioman_finder)
        #debug('  camouflage: %s' % str(self.camouflage))
        #debug('  brothers_in_arms: %s' % str(self.brothers_in_arms))

        # Check for Stereoscope
        self.stereoscope = self._isOptionalEquipped('stereoscope')
        #debug('  stereoscope: %s' % str(self.stereoscope))

        # Check for Ventilation
        self.ventilation = self._isOptionalEquipped('improvedVentilation')
        #debug('  ventilation: %s' % str(self.ventilation))

        # Check for Coated Optics
        self.coated_optics = self._isOptionalEquipped('coatedOptics')
        #debug('  coated_optics: %s' % str(self.coated_optics))

        # Check for rammer
        self.rammer = self._isOptionalEquipped('Rammer')
        #debug('  rammer: %s' % str(self.rammer))

        # Check for Consumable (cola, chocolate etc.)
        self.consumable = self._isStimulatorEquipped()
        #debug('  consumable: %s' % str(self.consumable))

        descr = self.vehicleItem.descriptor

        # debug(vars(descr))
        # debug(vars(descr.type))

        # View Range
        if isReplay():
            self.view_distance_vehicle = descr.turret.circularVisionRadius

        # Shell Range & Artillery Range
        isArty = 'SPG' in descr.type.tags
        shell_range = 0
        artillery_ranges = []
        artillery_shellsCD = []
        for shell in descr.gun.shots:
            shell_range = max(shell_range, shell.maxDistance)
            if isArty:
                pitchLimits = abs(descr.gun.pitchLimits['absolute'][0])
                if pitchLimits >= (math.pi / 4):
                    artillery_ranges.append(round(math.pow(shell.speed, 2) / shell.gravity))
                else:
                    artillery_ranges.append(round(math.sin(2 * pitchLimits) * math.pow(shell.speed, 2) / shell.gravity))
                artillery_shellsCD.append(shell.shell.compactDescr)

        # do not show for range more then 707m (maximum marker visibility range)
        if shell_range >= 707:
            shell_range = 0

        # log(descr.gun)
        # log(descr.radio)

        # Set values
        self.minimapCirclesData = {
            'vehCD': descr.type.compactDescr,
            'is_full_crew': self.is_full_crew,
            'base_commander_skill': self.base_commander_skill,
            'base_radioman_skill': self.base_radioman_skill,
            'base_loaders_skill': self.base_loaders_skill,
            'view_distance_vehicle': self.view_distance_vehicle,
            'view_brothers_in_arms': self.brothers_in_arms,
            'view_stereoscope': self.stereoscope,
            'view_ventilation': self.ventilation,
            'view_coated_optics': self.coated_optics,
            'view_rammer': self.rammer,
            'view_consumable': self.consumable,
            'view_commander_eagleEye': self.commander_eagleEye,
            'view_radioman_finder': self.radioman_finder,
            'view_radioman_inventor': self.radioman_inventor,
            'view_camouflage': self.camouflage,
            'artillery_ranges': artillery_ranges,
            'artillery_shellsCD': artillery_shellsCD,
            'shell_range': shell_range,
            'base_gun_reload_time': float("{0:.3f}".format(descr.gun.reloadTime)),
            'base_radio_distance': descr.radio.distance,
            'commander_sixthSense': self.commander_sixthSense,
        }


    # PRIVATE

    def _updateCrew(self):
        self.crew = []
        self.is_full_crew = True

        tankmen = self.itemsCache.items.getTankmen()
        for tankman in tankmen.itervalues():
            for slotIdx, crewman in self.vehicleItem.crew:
                if crewman is None:
                    self.is_full_crew = False
                elif crewman.invID == tankman.invID:
                    level = tankman.roleLevel
                    # Needed on Lesta while not on WG
                    if IS_LESTA:
                        level *= tankman.descriptor.efficiencyOnVehicle(self.vehicleItem.descriptor)

                    crew_member = {
                        'position': slotIdx,
                        'isFemale': tankman.descriptor.isFemale,
                        'level': level,
                        'skill': {}
                    }

                    skills = []
                    for skill_name in tankman.descriptor.skills:
                        skills.append({'name': skill_name, 'level': 100})

                    if len(skills) != 0:
                        skills[-1]['level'] = tankman.descriptor.lastSkillLevel

                    for skill in skills:
                        crew_member['skill'][skill['name']] = skill['level']

                    # debug(tankman.descriptor.role + " " + str(crew_member['level']))
                    self.crew.append({'name': tankman.descriptor.role, 'data': crew_member})

    def _isOptionalEquipped(self, optional_name):
        for item in self.vehicleItem.descriptor.optionalDevices:
            # debug(vars(item))
            if item is not None and optional_name in item.name:
                return True
        return False

    # cola, chocolate etc.
    def _isStimulatorEquipped(self):
        for item in self.vehicleItem.consumables.installed:
            # debug(vars(item))
            if item is not None and item.isStimulator:
                return True
        return False

_g_minimap_circles = _MinimapCircles()
